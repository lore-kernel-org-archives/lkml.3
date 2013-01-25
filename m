Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3AYDvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:51:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372Ab3AYDvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:51:04 -0500
Message-ID: <51020120.5000500@redhat.com>
Date: Fri, 25 Jan 2013 11:50:56 +0800
From: Lingzhu Xiang <lxiang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] efivars write(2) races
References: <20130125002552.GC4503@ZenIV.linux.org.uk>
In-Reply-To: <20130125002552.GC4503@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 08:25 AM, Al Viro wrote:
> 	1) process A does write() on efivars file, reaches ->get_variable(),
> gets newdatasize set, drops efivars->lock and loses CPU before an attempt to
> grab ->i_mutex.  process B comes and does the same thing, replacing the
> variable contents.  Then it grabs ->i_mutex, updates size, drops ->i_mutex
> and buggers off.  At which point A gets CPU back and proceeds to set size
> to whatever would be valid for its write.  Only the value is bogus now...

There are a few other things that makes size bogus now.

1. truncate() never touches nvram but pretends to be changing size.

2. Empty files come back with non-zero size after remount. They are imported
   from sysfs when mounting.

3. Arguably reading empty files could just return empty instead of returning
   EIO/EFI_NOT_FOUND from firmware. 

4. EFI_VARIABLE_APPEND_WRITE with EFI_OUT_OF_RESOURCES truncates size but you
   can still read its content.
