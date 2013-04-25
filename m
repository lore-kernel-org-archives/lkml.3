Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab3DYOQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:16:42 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54909 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab3DYOQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:16:41 -0400
X-Nat-Received: from [202.181.97.72]:54788 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1366899382.22496
To: casey@schaufler-ca.com, john.johansen@canonical.com
Cc: paul@paul-moore.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, jmorris@namei.org,
        eparis@redhat.com, keescook@chromium.org
Subject: Re: [PATCH v13 0/9] LSM: Multiple concurrent LSMs
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <3554062.6nBMExN24s@sifl>
	<51783EFC.8050607@schaufler-ca.com>
	<3235150.vl4U7U54yV@sifl>
	<517863F8.7050606@canonical.com>
	<51787C1C.1040301@schaufler-ca.com>
In-Reply-To: <51787C1C.1040301@schaufler-ca.com>
Message-Id: <201304252316.GDF26577.FtVFHOOSQMJFOL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 25 Apr 2013 23:16:23 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 25042013 #9893482, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> >> I'm still in favor of assigning the network hooks to the LSM at boot based on 
> >> the "security=" configuration.
> >>
> > yeah dealing with selection at boot time is going to be needed
> > at some point, whether its now or later ...
> 
> I'll have a go at it then. What that would mean is that:
> 
> 	security=smack,selinux
> 
> gives Smack NetLabel and SELinux xfrm and secmark while
> 
> 	security=selinux,smack
> 
> gives SELinux all three. I would still like it to be possible to
> explicitly configure the allocation at build time.

The problem is that it is difficult to control the registration order since
each LSM module directly calls security_initcall() for registering themselves?

Then, what about replacing

  static int __init foo_init()
  {
    register_security(&foo_security_ops);
    return 0;
  }
  security_initcall(foo_init);

  static int __init bar_init()
  {
    register_security(&bar_security_ops);
    return 0;
  }
  security_initcall(bar_init);

with

  static int __init foo_init()
  {
    register_security(&foo_security_ops);
    return 0;
  }

  static int __init bar_init()
  {
    register_security(&bar_security_ops);
    return 0;
  }

  static int __init add_foo(void) {
    foo_security_ops.register = foo_init;
    list_add_tail(&foo_security_ops.list[lsm_candidate], &lsm_hooks[lsm_candidate]);
    return 0;
  }
  pure_initcall(add_foo);

  static int __init add_bar(void) {
    bar_security_ops.register = bar_init;
    list_add_tail(&bar_security_ops.list[lsm_candidate], &lsm_hooks[lsm_candidate]);
    return 0;
  }
  pure_initcall(add_bar);

and let security/security.c register in accordance with
security= parameter (or compile-time config if none given)?

  static int __init register_lsms(void)
  {
    for_each_comma_separated_lsm_names_given() {
      bool found = 0;
      list_for_each_entry_safe(ops, tmp, &lsm_hooks[lsm_candidate]) {
        if (!strcmp(ops->name, name)) {
          if (ops->register() == 0)
            list_del(&ops->list[lsm_candidate]);
          found = 1;
          break;
        }
      }
      if (!found) {
        printk("LSM module %s was not found\n", name);
      }
    }
    list_for_each_entry_safe(ops, tmp, &lsm_hooks[lsm_candidate]) {
      list_del(&ops->list[lsm_candidate]);
      printk("LSM module %s was not enabled\n", ops->name);
    }
  }
  security_initcall(register_lsms);

(Well, list_add_tail() in pure_initcall functions should be optimized
 by statically embedding into security/security.c at compile time?)
