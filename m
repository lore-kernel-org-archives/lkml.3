Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab3AYNSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:18:13 -0500
Received: from mga05.intel.com ([192.55.52.89]:30246 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757275Ab3AYNSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:18:10 -0500
Message-ID: <1359119883.2496.156.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [RFC] efivars write(2) races
From: Matt Fleming <matt.fleming@intel.com>
To: Lingzhu Xiang <lxiang@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Fri, 25 Jan 2013 13:18:03 +0000
In-Reply-To: <51020120.5000500@redhat.com>
References: <20130125002552.GC4503@ZenIV.linux.org.uk>
	 <51020120.5000500@redhat.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 11:50 +0800, Lingzhu Xiang wrote:
> On 01/25/2013 08:25 AM, Al Viro wrote:
> > 	1) process A does write() on efivars file, reaches ->get_variable(),
> > gets newdatasize set, drops efivars->lock and loses CPU before an attempt to
> > grab ->i_mutex.  process B comes and does the same thing, replacing the
> > variable contents.  Then it grabs ->i_mutex, updates size, drops ->i_mutex
> > and buggers off.  At which point A gets CPU back and proceeds to set size
> > to whatever would be valid for its write.  Only the value is bogus now...
> 
> There are a few other things that makes size bogus now.
> 
> 1. truncate() never touches nvram but pretends to be changing size.

Good catch. Looks like we need to provide an implementation for this.

> 2. Empty files come back with non-zero size after remount. They are imported
>    from sysfs when mounting.

Eeek. The return value of get_variable() isn't checked in
efivarfs_fill_super().

> 3. Arguably reading empty files could just return empty instead of returning
>    EIO/EFI_NOT_FOUND from firmware. 

Yeah, I think Jeremy has a patch to fix this.

> 4. EFI_VARIABLE_APPEND_WRITE with EFI_OUT_OF_RESOURCES truncates size but you
>    can still read its content.

I'm not sure what you mean by this. Could you please explain?

Thanks for the feedback.

