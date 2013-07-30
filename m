Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447Ab3G3XQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 19:16:59 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:35818 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239Ab3G3XQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 19:16:56 -0400
Date: Tue, 30 Jul 2013 16:16:51 -0700
Message-ID: <20130730161651.Horde.PkwqiJir309R_EljyDbxlqA@imap.linux.ibm.com>
From: Zach Levis <zml@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Zach Levis <zach@zachsthings.com>
Subject: Re: [PATCH 2/3] fs/binfmts: Better handling of binfmt loops
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
 <1374766845-13565-2-git-send-email-zml@linux.vnet.ibm.com>
 <20130730140446.1a4982e21ac8e183c65e9ed1@linux-foundation.org>
In-Reply-To: <20130730140446.1a4982e21ac8e183c65e9ed1@linux-foundation.org>
User-Agent: Internet Messaging Program (IMP) H4 (5.0.22)
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073023-3620-0000-0000-000003BE5105
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Quoting Andrew Morton <akpm@linux-foundation.org>:

> On Thu, 25 Jul 2013 08:40:44 -0700 Zach Levis <zml@linux.vnet.ibm.com> wrote:
>
>> With these changes, when a binfmt loop is encountered,
>> the ELOOP will propogate back to the 0 depth. At this point the
>> argv and argc values will be reset to what they were originally and an
>> attempt is made to continue with the following binfmt handlers.
>
> hm, why?  What problem does this fix?  What value does the change offer
> to our users?

This is used when the binfmt_misc,script,etc options are configured in  
a way that would previously prevent executables from launching that  
could be executed with a different binfmt but don't because of a loop  
in a prior binfmt.

Example: a qemu is configured to run 64-bit ELFs on an otherwise  
32-bit system. The system's owner switches to running with 64-bit  
executables, but forgets to disable the binfmt_misc option that  
redirects 64bit ELFs to qemu. Since the qemu executable is a 64-bit  
ELF now, binfmt_misc keeps on matching it with the qemu rule,  
preventing the execution of any 64-bit binary.

With this patch, an error is printed and search_binary_handler()  
continues on to the next handler, allowing the original executable to  
run normally so the user can (hopefully) fix their misconfiguration  
more easily.

