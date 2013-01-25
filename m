Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab3AYMud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:50:33 -0500
Received: from mga07.intel.com ([143.182.124.22]:32599 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756744Ab3AYMu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:50:28 -0500
Message-ID: <1359118221.2496.150.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [RFC] efivars write(2) races
From: Matt Fleming <matt.fleming@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lingzhu Xiang <lxiang@redhat.com>
Date: Fri, 25 Jan 2013 12:50:21 +0000
In-Reply-To: <20130125002552.GC4503@ZenIV.linux.org.uk>
References: <20130125002552.GC4503@ZenIV.linux.org.uk>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 00:25 +0000, Al Viro wrote:
> 	1) process A does write() on efivars file, reaches ->get_variable(),
> gets newdatasize set, drops efivars->lock and loses CPU before an attempt to
> grab ->i_mutex.  process B comes and does the same thing, replacing the
> variable contents.  Then it grabs ->i_mutex, updates size, drops ->i_mutex
> and buggers off.  At which point A gets CPU back and proceeds to set size
> to whatever would be valid for its write.  Only the value is bogus now...

Crap, yes. We'll have to jiggle the locking rules around to fix this
one.

> 	2) what's to prevent EFI_NOT_FOUND being hit twice?  Bad things
> will obviously happen in that case...

I'm not sure which execution path will trigger this? Oh, if we're
spinning for the spinlock in efivarfs_unlink() while another process
does a delete via efivarfs_file_write()? Yeah, that's gonna cause some
tears.

Thanks, Al.

