Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3JCVbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:31:50 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50831 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab3JCVbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:31:49 -0400
X-Nat-Received: from [202.181.97.72]:51572 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1380835907.20944
To: kees@outflux.net, keescook@chromium.org
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, james.l.morris@oracle.com,
        casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
        rusty@rustcorp.com.au
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20130920203556.GA8726@www.outflux.net>
	<alpine.LRH.2.02.1309241124420.3782@tundra.namei.org>
	<alpine.LRH.2.02.1309241128430.3782@tundra.namei.org>
	<CAGXu5jJ9t7tet4Bx=VUaVmjp1C18iK-nLpQBgmXqgukoAmmd4A@mail.gmail.com>
	<20131003205515.GF5729@outflux.net>
In-Reply-To: <20131003205515.GF5729@outflux.net>
Message-Id: <201310040631.IIF39022.OVFOFQOtJSFHLM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 4 Oct 2013 06:31:42 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 03102013 #11172924, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> +static int modpin_load_module(struct file *file)
> +{
> +   struct dentry *module_root;
> +
> +   if (!file) {
> +           if (!modpin_enforced) {
> +                   report_load_module(NULL, "old-api-pinning-ignored");
> +                   return 0;
> +           }
> +
> +           report_load_module(NULL, "old-api-denied");
> +           return -EPERM;
> +   }
> +
> +   module_root = file->f_path.mnt->mnt_root;
> +
> +   /* First loaded module defines the root for all others. */
> +   spin_lock(&pinned_root_spinlock);
> +   if (!pinned_root) {
> +           pinned_root = dget(module_root);
> +           /*
> +            * Unlock now since it's only pinned_root we care about.
> +            * In the worst case, we will (correctly) report pinning
> +            * failures before we have announced that pinning is
> +            * enabled. This would be purely cosmetic.
> +            */
> +           spin_unlock(&pinned_root_spinlock);
> +           check_pinning_enforcement();
> +           report_load_module(&file->f_path, "pinned");
> +           return 0;
> +   }
> +   spin_unlock(&pinned_root_spinlock);

Firstly loaded module is usually in initramfs whereas subsequently loaded
modules are usually on a hard disk partition.

This module is not meant for PC servers, is it?
