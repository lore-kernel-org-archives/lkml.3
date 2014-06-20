Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934527AbaFTU3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:29:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39748 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086AbaFTU3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:29:08 -0400
Date: Fri, 20 Jun 2014 22:29:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, mattieu.souchaud@free.fr
Subject: Re: [PATCH] x86/mce: Don't unregister CPU hotplug notifier in error
 path
Message-ID: <20140620202900.GL11391@pd.tnic>
References: <1403274493-1371-1-git-send-email-boris.ostrovsky@oracle.com>
 <20140620152312.GB11391@pd.tnic>
 <53A45627.6090306@oracle.com>
 <20140620155845.GC11391@pd.tnic>
 <53A45E67.7070000@oracle.com>
 <20140620175240.GE11391@pd.tnic>
 <53A48DF6.9020503@oracle.com>
 <20140620200358.GK11391@pd.tnic>
 <53A496B2.2090701@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53A496B2.2090701@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 04:16:50PM -0400, Boris Ostrovsky wrote:
> Sorry, mce_device_create().
> 
> We can't call it in the notifier until mcheck_init_device() has been
> successfully executed (we need subsys_system_register(&mce_subsys)). I don't
> know whether we can call subsys_system_register() in mcheck_init() -- it is
> quite early in the boot.

I don't think it matters: we want to add only this oneliner to
mcheck_init():

	__register_hotcpu_notifier(&mce_cpu_notifier);

and remove it from mcheck_init_device(), nothing else. And we don't need
the synchronization even because we're BSP only then.

I mean, we won't be able to offline CPUs that early anyway - thus
call mce_device_create() in the notifier callback - as we don't have
userspace to do "echo 0 > ..."

The rest of the code remains and mcheck_init_device() executes when it
does. Unless I'm missing something, of course...

Oh, not quite. We probably should remove the

	__unregister_hotcpu_notifier(&mce_cpu_notifier);

from the error path too, as you suggest.

When you do, please hold that down in the commit message so that it is
clear what we're doing.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
