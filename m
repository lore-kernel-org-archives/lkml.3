Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbaLQWpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:45:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbaLQWpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:45:02 -0500
Date: Wed, 17 Dec 2014 17:44:47 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, linux-audit@redhat.com
Subject: Re: linux-next 20141216 BUG: sleeping function called from invalid
 context at mm/slab.c:2849
Message-ID: <20141217224447.GA29827@madcap2.tricolour.ca>
References: <2966.1418778594@turing-police.cc.vt.edu>
 <1418779308.3025.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418779308.3025.1.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/12/16, Eric Paris wrote:
> I haven't looked into it, but I'd place my first bet on the audit
> multicast code...

Any particular reason for the multicast code (other than the obvious
skb_copy added)?  That stuff went upstream 8 months ago rather than this
linux-next window of 20141208 to 20141216.  There are people using it
(as evidenced by a bug report and a patch to fix incorrect size
reporting has gone upstream).  So I doubt it would be that unless
something new was interacting with it.

I'd more suspect 9eab339b197a6903043d272295dcb716ff739b21 [ audit: get
comm using lock to avoid race in string printing ] in which the call to
get_task_comm() might be more safely be replaced with memcpy() as in
https://lkml.org/lkml/2014/11/16/184

> Richard?
> 
> On Tue, 2014-12-16 at 20:09 -0500, Valdis Kletnieks wrote:
> > Not sure who's to blame here, but I'm tending towards selinux based on
> > who was holding the locks...
> > 
> > Spotted these two while booting single-user on 20141216.  20141208
> > doesn't throw these, so it's something in the last week or so..
> > 
> > Tossed it twice - once for /sbin/sulogin, and then a second time for /bin/bash.
> > 
> > [   34.061285] BUG: sleeping function called from invalid context at mm/slab.c:2849
> > [   34.062863] in_atomic(): 1, irqs_disabled(): 0, pid: 885, name: sulogin
> > [   34.064416] 2 locks held by sulogin/885:
> > [   34.064418]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff91152e30>] prepare_bprm_creds+0x28/0x8b
> > [   34.064428]  #1:  (tty_files_lock){+.+.+.}, at: [<ffffffff9123e787>] selinux_bprm_committing_creds+0x55/0x22b
> > [   34.064438] CPU: 1 PID: 885 Comm: sulogin Not tainted 3.18.0-next-20141216 #30
> > [   34.064440] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A15 06/20/2014
> > [   34.064442]  ffff880223744f10 ffff88022410f9b8 ffffffff916ba529 0000000000000375
> > [   34.064447]  ffff880223744f10 ffff88022410f9e8 ffffffff91063185 0000000000000006
> > [   34.064452]  0000000000000000 0000000000000000 0000000000000000 ffff88022410fa38
> > [   34.064457] Call Trace:
> > [   34.064463]  [<ffffffff916ba529>] dump_stack+0x50/0xa8
> > [   34.064467]  [<ffffffff91063185>] ___might_sleep+0x1b6/0x1be
> > [   34.064472]  [<ffffffff910632a6>] __might_sleep+0x119/0x128
> > [   34.064477]  [<ffffffff91140720>] cache_alloc_debugcheck_before.isra.45+0x1d/0x1f
> > [   34.064480]  [<ffffffff91141d81>] kmem_cache_alloc+0x43/0x1c9
> > [   34.064484]  [<ffffffff914e148d>] __alloc_skb+0x42/0x1a3
> > [   34.064488]  [<ffffffff914e2b62>] skb_copy+0x3e/0xa3
> > [   34.064492]  [<ffffffff910c263e>] audit_log_end+0x83/0x100
> > [   34.064496]  [<ffffffff9123b8d3>] ? avc_audit_pre_callback+0x103/0x103
> > [   34.064500]  [<ffffffff91252a73>] common_lsm_audit+0x441/0x450
> > [   34.064503]  [<ffffffff9123c163>] slow_avc_audit+0x63/0x67
> > [   34.064506]  [<ffffffff9123c42c>] avc_has_perm+0xca/0xe3
> > [   34.064510]  [<ffffffff9123dc2d>] inode_has_perm+0x5a/0x65
> > [   34.064514]  [<ffffffff9123e7ca>] selinux_bprm_committing_creds+0x98/0x22b
> > [   34.064519]  [<ffffffff91239e64>] security_bprm_committing_creds+0xe/0x10
> > [   34.064522]  [<ffffffff911515e6>] install_exec_creds+0xe/0x79
> > [   34.064527]  [<ffffffff911974cf>] load_elf_binary+0xe36/0x10d7
> > [   34.064542]  [<ffffffff9115198e>] search_binary_handler+0x81/0x18c
> > [   34.064545]  [<ffffffff91153376>] do_execveat_common.isra.31+0x4e3/0x7b7
> > [   34.064548]  [<ffffffff91153669>] do_execve+0x1f/0x21
> > [   34.064552]  [<ffffffff91153967>] SyS_execve+0x25/0x29
> > [   34.064557]  [<ffffffff916c61a9>] stub_execve+0x69/0xa0
> > 
> > [   48.826654] BUG: sleeping function called from invalid context at mm/slab.c:2849
> > [   48.829282] in_atomic(): 1, irqs_disabled(): 0, pid: 885, name: bash
> > [   48.829284] 2 locks held by bash/885:
> > [   48.829297]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff91152e30>] prepare_bprm_creds+0x28/0x8b
> > [   48.829307]  #1:  (&(&newf->file_lock)->rlock){+.+.+.}, at: [<ffffffff91166b8b>] iterate_fd+0x34/0x11c
> > [   48.829310] CPU: 3 PID: 885 Comm: bash Not tainted 3.18.0-next-20141216 #30
> > [   48.829311] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A15 06/20/2014
> > [   48.829317]  ffff880223744f10 ffff88022410f928 ffffffff916ba529 0000000000000375
> > [   48.829321]  ffff880223744f10 ffff88022410f958 ffffffff91063185 0000000000000002
> > [   48.829325]  0000000000000000 0000000000000000 0000000000000000 ffff88022410f9a8
> > [   48.829327] Call Trace:
> > [   48.829333]  [<ffffffff916ba529>] dump_stack+0x50/0xa8
> > [   48.829338]  [<ffffffff91063185>] ___might_sleep+0x1b6/0x1be
> > [   48.829341]  [<ffffffff910632a6>] __might_sleep+0x119/0x128
> > [   48.829347]  [<ffffffff91140720>] cache_alloc_debugcheck_before.isra.45+0x1d/0x1f
> > [   48.829350]  [<ffffffff91141d81>] kmem_cache_alloc+0x43/0x1c9
> > [   48.829356]  [<ffffffff914e148d>] __alloc_skb+0x42/0x1a3
> > [   48.829360]  [<ffffffff914e2b62>] skb_copy+0x3e/0xa3
> > [   48.829367]  [<ffffffff910c263e>] audit_log_end+0x83/0x100
> > [   48.829372]  [<ffffffff9123b8d3>] ? avc_audit_pre_callback+0x103/0x103
> > [   48.829377]  [<ffffffff91252a73>] common_lsm_audit+0x441/0x450
> > [   48.829381]  [<ffffffff9123c163>] slow_avc_audit+0x63/0x67
> > [   48.829386]  [<ffffffff9123c42c>] avc_has_perm+0xca/0xe3
> > [   48.829391]  [<ffffffff9123e255>] ? selinux_file_permission+0x9b/0x9b
> > [   48.829395]  [<ffffffff9123e0b9>] file_has_perm+0x6d/0x7c
> > [   48.829400]  [<ffffffff9123e283>] match_file+0x2e/0x3b
> > [   48.829404]  [<ffffffff91166c4b>] iterate_fd+0xf4/0x11c
> > [   48.829409]  [<ffffffff9123e802>] selinux_bprm_committing_creds+0xd0/0x22b
> > [   48.829415]  [<ffffffff91239e64>] security_bprm_committing_creds+0xe/0x10
> > [   48.829419]  [<ffffffff911515e6>] install_exec_creds+0xe/0x79
> > [   48.829426]  [<ffffffff911974cf>] load_elf_binary+0xe36/0x10d7
> > [   48.829431]  [<ffffffff9115198e>] search_binary_handler+0x81/0x18c
> > [   48.829435]  [<ffffffff91153376>] do_execveat_common.isra.31+0x4e3/0x7b7
> > [   48.829462]  [<ffffffff91153669>] do_execve+0x1f/0x21
> > [   48.829466]  [<ffffffff91153967>] SyS_execve+0x25/0x29
> > [   48.829472]  [<ffffffff916c61a9>] stub_execve+0x69/0xa0
> > 
> 
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
