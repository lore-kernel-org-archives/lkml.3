Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaLFRFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:05:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:25096 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaLFRFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:05:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="425934872"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Tristan Lelong <tristan@lelong.xyz>, Greg KH <gregkh@linuxfoundation.org>
CC: "Drokin, Oleg" <oleg.drokin@intel.com>,
        "askb23@gmail.com" <askb23@gmail.com>,
        "Hammond, John" <john.hammond@intel.com>,
        "gdonald@gmail.com" <gdonald@gmail.com>,
        "anhlq2110@gmail.com" <anhlq2110@gmail.com>,
        "fabio.falzoi84@gmail.com" <fabio.falzoi84@gmail.com>,
        "oort10@gmail.com" <oort10@gmail.com>,
        "agimenez@sysvalve.es" <agimenez@sysvalve.es>,
        "rupran@einserver.de" <rupran@einserver.de>,
        "surya.seetharaman9@gmail.com" <surya.seetharaman9@gmail.com>,
        "Julia.Lawall@lip6.fr" <Julia.Lawall@lip6.fr>,
        "joe@perches.com" <joe@perches.com>,
        "a.terekhov@gmail.com" <a.terekhov@gmail.com>,
        "vthakkar1994@gmail.com" <vthakkar1994@gmail.com>,
        "amk@cray.com" <amk@cray.com>,
        "srikrishanmalik@gmail.com" <srikrishanmalik@gmail.com>,
        "rd@radekdostal.com" <rd@radekdostal.com>,
        "bergwolf@gmail.com" <bergwolf@gmail.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "Gortmaker, Paul (Wind River)" <paul.gortmaker@windriver.com>,
        "tapaswenipathak@gmail.com" <tapaswenipathak@gmail.com>,
        "email@christophjaeger.info" <email@christophjaeger.info>,
        "uja.ornl@gmail.com" <uja.ornl@gmail.com>,
        "brilliantov@inbox.ru" <brilliantov@inbox.ru>,
        "Eremin, Dmitry" <dmitry.eremin@intel.com>,
        "HPDD-discuss@lists.01.org" <HPDD-discuss@ml01.01.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: lustre: fix sparse warning on LPROC_SEQ_FOPS
 macros
Thread-Topic: [PATCH] staging: lustre: fix sparse warning on LPROC_SEQ_FOPS
 macros
Thread-Index: AQHQEGIihcdQjKY+U0OvYsGcxFufZ5yCCduAgAAUxYCAAL70AA==
Date: Sat, 6 Dec 2014 17:05:14 +0000
Message-ID: <D0A87E89.CDFB9%andreas.dilger@intel.com>
References: <1417766627-5232-1-git-send-email-tristan@lelong.xyz>
 <20141205212723.GA22536@kroah.com>
 <20141205224143.GB5698@localhost.localdomain>
In-Reply-To: <20141205224143.GB5698@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.86.108]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A427858BB6001E40AB4DF327D5F1271E@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/05, 3:41 PM, "Tristan Lelong" <tristan@lelong.xyz> wrote:

>On Fri, Dec 05, 2014 at 01:27:23PM -0800, Greg KH wrote:
>> On Fri, Dec 05, 2014 at 12:03:47AM -0800, Tristan Lelong wrote:
>> >  static ssize_t
>> > -fld_proc_hash_seq_write(struct file *file, const char *buffer,
>> > -			size_t count, loff_t *off)
>> > +fld_proc_hash_seq_write(struct file *file,
>> > +				const char __user *buffer,
>> > +				size_t count, loff_t *off)
>> >  {
>> >  	struct lu_client_fld *fld;
>> >  	struct lu_fld_hash *hash = NULL;
>> > +	char name[80];
>> >  	int i;
>> >  
>> > +	if (count > 80)
>> > +		return -ENAMETOOLONG;
>> > +
>> > +	if (copy_from_user(name, buffer, count) != 0)
>> > +		return -EFAULT;
>> 
>> How was this code ever working before?
>
>I have no idea, and was actually surprised that this was there.
>
>> 
>> And I know Joe asked, but how do you know that 80 is ok?  And why on the
>> stack?
>
>80 is the sizeof(struct lu_fld_hash.fh_name) and there is no define for
>that.  A few other structure members are using this 80 value internally,
>and as I told Joe, I will analyze if they are all related and submit a
>patch to use a define instead.

Sorry, but I don't see where you get 80 from?  fh_name is declared as a
"const char *", and initialized in the declaration of fld_hash[].  I'd
thought to reply that sizeof(fh_name) would even be better than a #define,
but sizeof(const char *) doesn't actually make sense.

The longest declared fh_name is 4 characters, but I'm not sure of an easy
way to determine this at compile time.  I guess one option is to change
the declaration of struct lu_fld_hash to use "const char fh_name[4];" and
then use sizeof(fh_name), but I don't know if that is better than just
declaring a small buffer (8 chars) for this usage.  IMHO that is small
enough to fit on the stack, since it is at the top of a very short
callchain (userspace->sys_write->vfs_write->fld_proc_hash_seq_write())
that just saves the value so the chance of stack overflow is basically nil.

>> 
>> Shouldn't you just compare count to strlen(fld_hash[i].fh_name)? like
>>you
>> do later on?
>> 
>
>This is actually done in the for loop already. I first compare with the
>maximum size, then the loop use the strlen of each entries in the table,
>and finally does the strncmp.
>
>> 
>> Anyway, I don't like large stack variables like this, can you make it
>> dynamic instead?
>> 
>
>I can definitely do this with a kmalloc, I'll submit a v2 tonight.
>
>Thanks
>


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


