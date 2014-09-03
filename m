Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaICDMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:12:08 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:57160 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbaICDMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:12:06 -0400
Message-ID: <540686FF.4060907@hitachi.com>
Date: Wed, 03 Sep 2014 12:11:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [RFC PATCH 0/5] module: Remove stop_machine from module unloading
References: <20140825105520.21089.26870.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140825105520.21089.26870.stgit@kbuild-fedora.novalocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping? :)

(2014/08/25 19:55), Masami Hiramatsu wrote:
> Hi,
> 
> Here is a series of patches which remove stop_machine() from
> module unloading.
> 
> Currently, each module unloading calls stop_machine()s 2 times.
> One is for safely removing module from lists and one is to
> check the reference counter. However, both are not necessary
> for those purposes (required by current implementation).
> 
> First, we can use RCU for the list operation, we just need
> a synchronize_rcu right before cleaning up.
> Second, the reference counter can be checked atomically by
> using atomic_t, instead of per-cpu module_ref. Of course,
> for BIG SMP machines, atomic operation is not efficient.
> However, they usually don't need to remove most of modules too.
> 
> In this series, I just fixed to use RCU for the module(and
> bugs) list for the first stop_machine.
> And for the second one, I replaced module_ref with atomic_t
> and introduced a "module lockup" module load option, which
> makes a module un-removable (lock up the module in kernel).
> The lockup modules can not be removed except forced, and the
> kernel skips module refcounting on those modules. Thus we
> can minimize the performance impact on the BIG SMP machines.
> 
> BTW, of course this requires to update libkmod to support
> new MODULE_INIT_LOCKUP_MODULE flag. I'm not sure where is
> good to send the patches I have. Sould I better sending
> kmod patches on LKML?
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (5):
>       module: Wait for RCU synchronizing before releasing a module
>       module: Unlink module with RCU synchronizing instead of stop_machine
>       lib/bug: Use RCU list ops for module_bug_list
>       module: Lock up a module when loading with a LOCLUP flag
>       module: Remove stop_machine from module unloading
> 
> 
>  include/linux/module.h        |   22 ++----
>  include/trace/events/module.h |    2 -
>  include/uapi/linux/module.h   |    1 
>  kernel/module.c               |  147 +++++++++++++++++------------------------
>  lib/bug.c                     |   20 ++++--
>  5 files changed, 85 insertions(+), 107 deletions(-)
> 
> --
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


