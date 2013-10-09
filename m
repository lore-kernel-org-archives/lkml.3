Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3JIQh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 12:37:57 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:33625 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3JIQhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 12:37:55 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: RE: [RFC][PATCH v2] efivars,efi-pstore: Hold off deletion of sysfs
 entry until the scan is completed
Thread-Topic: [RFC][PATCH v2] efivars,efi-pstore: Hold off deletion of sysfs
 entry until the scan is completed
Thread-Index: AQHOu7+XfunCBWQX5U2oS2J+506e65npcBwAgAMsutA=
Date: Wed, 9 Oct 2013 16:37:13 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443EED4D0@USINDEM103.corp.hds.com>
References: <5245E958.5040602@hds.com>
 <20131007114218.GA14773@console-pimps.org>
In-Reply-To: <20131007114218.GA14773@console-pimps.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-09_05:2013-10-09,2013-10-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310090059
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for reviewing.
In my understanding, your point is that all accesses to efivar_entry should be done while holding __efivars->lock.

> > @@ -88,8 +103,9 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
> >  		return 0;
> >
> >  	entry->var.DataSize = 1024;
> > -	__efivar_entry_get(entry, &entry->var.Attributes,
> > -			   &entry->var.DataSize, entry->var.Data);
> > +	efivar_entry_get(entry, &entry->var.Attributes,
> > +			 &entry->var.DataSize, entry->var.Data);
> > +
> >  	size = entry->var.DataSize;
> >
> >  	*cb_data->buf = kmemdup(entry->var.Data, size, GFP_KERNEL);
> 
> This isn't safe to do without holding the __efivars->lock, because
> there's the potential for someone else to update entry->var.Data and
> entry->var.DataSize while you're in the middle of copying the data in
> kmemdup(). This could leak to an information leak, though I think you're
> safe from an out-of-bounds access because DataSize is never > 1024.
> 

I see...
Bu, kmemdup() cannot be called while holding the spinlock.

So, for protecting efivar_entry, I will call kzalloc() before holding the lock in efi_pstore_read().
and use memcpy() in efi_pstore_read_func().

The pseudo code is as below.

	static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 				       struct pstore_info *psi)
 	{
		*data.buf = kzalloc(1024, GFP_KERNEL);
		if (!*data.buf)
			return -ENOMEM;

		efivar_entry_iter_begin();
		size = efi_pstore_sysfs_entry_iter(&data,
						   (struct efivar_entry **)&psi->data);
		efivar_entry_iter_end();
		if (size <= 0)
			kfree(*data.buf);
		return size;
 	}

	static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 	{
	[...]
		entry->var.DataSize = 1024;
 		__efivar_entry_get(entry, &entry->var.Attributes,
				 &entry->var.DataSize, entry->var.Data);

 		size = entry->var.DataSize;
		memcpy(*cb_data->buf, entry->var.Data, (size_t)min_t(unsigned long,
								     1024, size)); 
		return size;
	}


> This doesn't look correct to me. You can't access 'entry' outside of the
> *_iter_begin() and *_iter_end() blocks. You can't do,
> 
> 	efivar_entry_iter_end():
> 
> 	if (!entry->scanning)
> 		efivar_unregister(entry);
> 
> because 'entry' may have already been freed by another CPU.

 I will fix it as follows.

	if (!entry->scanning) {
			efivar_entry_iter_end();
 			efivar_unregister(entry);
	}  else
			efivar_entry_iter_end();

(efivar_unregister(entry) still runs concurrently.
But, it cannot move inside spinlock because kzalloc() may run while freeing kobject.)

Is it your expectation?

Seiji

