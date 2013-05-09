Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3EIWBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:01:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3EIWBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:01:23 -0400
Date: Thu, 9 May 2013 15:01:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Russ Anderson <rja@sgi.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        <stable@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH -v8 01/11] CPU hotplug: Provide a generic helper to
 disable/enable CPU hotplug
Message-Id: <20130509150121.8c3ef60b2fc748ce542a1a52@linux-foundation.org>
In-Reply-To: <1367937595-32241-2-git-send-email-holt@sgi.com>
References: <1367937595-32241-1-git-send-email-holt@sgi.com>
	<1367937595-32241-2-git-send-email-holt@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 May 2013 09:39:45 -0500 Robin Holt <holt@sgi.com> wrote:

> From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> 
> There are instances in the kernel where we would like to disable
> CPU hotplug (from sysfs) during some important operation. Today
> the freezer code depends on this and the code to do it was kinda
> tailor-made for that.
> 
> Restructure the code and make it generic enough to be useful for
> other usecases too.
> 
> ...
>
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -141,6 +141,8 @@ static inline void unregister_cpu_notifier(struct notifier_block *nb)
>  }
>  #endif
>  
> +extern void cpu_hotplug_disable(void);
> +extern void cpu_hotplug_enable(void);
>  int cpu_up(unsigned int cpu);
>  void notify_cpu_starting(unsigned int cpu);
>  extern void cpu_maps_update_begin(void);
> @@ -148,6 +150,7 @@ extern void cpu_maps_update_done(void);
>  
>  #else	/* CONFIG_SMP */
>  
> +#define cpu_hotplug_disable()	do { } while (0)
>  #define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
>  

Breaks alpha allmodconfig because cpu_hotplug_disable() is absent from
vmlinux.

cpu_hotplug_disable() doesn't get compiled unless we've defined
CONFIG_PM_SLEEP_SMP.  I cannot begin to imagine what the logic is
behind that!

I'll stick this in there and see what happens.

--- a/include/linux/cpu.h~cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix
+++ a/include/linux/cpu.h
@@ -141,8 +141,6 @@ static inline void unregister_cpu_notifi
 }
 #endif
 
-extern void cpu_hotplug_disable(void);
-extern void cpu_hotplug_enable(void);
 int cpu_up(unsigned int cpu);
 void notify_cpu_starting(unsigned int cpu);
 extern void cpu_maps_update_begin(void);
@@ -150,7 +148,6 @@ extern void cpu_maps_update_done(void);
 
 #else	/* CONFIG_SMP */
 
-#define cpu_hotplug_disable()	do { } while (0)
 #define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 
 static inline int register_cpu_notifier(struct notifier_block *nb)
@@ -171,6 +168,15 @@ static inline void cpu_maps_update_done(
 }
 
 #endif /* CONFIG_SMP */
+
+#ifdef CONFIG_PM_SLEEP_SMP
+extern void cpu_hotplug_enable(void);
+extern void cpu_hotplug_disable(void);
+#else
+#define cpu_hotplug_enable()	do { } while (0)
+#define cpu_hotplug_disable()	do { } while (0)
+#endif
+
 extern struct bus_type cpu_subsys;
 
 #ifdef CONFIG_HOTPLUG_CPU

