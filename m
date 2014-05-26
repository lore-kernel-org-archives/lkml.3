Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaEZNZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:25:18 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:54876 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaEZNZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:25:16 -0400
Message-ID: <538340EE.7070408@linaro.org>
Date: Mon, 26 May 2014 15:26:06 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@suse.de,
        m.chehab@samsung.com, linux-edac@vger.kernel.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 4/7] acpi, apei, ghes: Factor out NMI error notification
 context.
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org> <1397056476-9183-5-git-send-email-tomasz.nowicki@linaro.org> <20140513194125.GD8760@pd.tnic> <537F39D7.6090309@linaro.org> <20140523164824.GG21332@pd.tnic>
In-Reply-To: <20140523164824.GG21332@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.05.2014 18:48, Borislav Petkov wrote:
> On Fri, May 23, 2014 at 02:06:47PM +0200, Tomasz Nowicki wrote:
>> I had that thoughts too. Looking at simple MCE calls, yes, it does
>> make sense to create corresponding arch-specific version and provide
>> logic as needed. I think that NMI is much more complicated....
>
> How about this ontop of your patches. It builds here but it is not
> trivial for me to try it on !X86. Maybe you can test it quicker than me
> finding some other arch box first... :)
>

Now I do follow :) Nicely done, I have applied your patch and indeed 
there are more arch dependencies for !X86. I created another patch (it 
can be applied on top of last patch set). Does it look reasonable?


diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 86f9301..0f03ab6 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -54,7 +54,18 @@ struct nmiaction {

  int __register_nmi_handler(unsigned int, struct nmiaction *);

-void unregister_nmi_handler(unsigned int, const char *);
+void unregister_nmi_handler(unsigned int type, const char *name);
+
+static inline int arch_apei_register_nmi(nmi_handler_t fn,
+					 const char *name)
+{
+	return register_nmi_handler(NMI_LOCAL, fn, 0, name);
+}
+
+static inline void arch_apei_unregister_nmi(const char *name)
+{
+	unregister_nmi_handler(NMI_LOCAL, name);
+}

  void stop_nmi(void);
  void restart_nmi(void);
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 35a44d9..84c79af 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -47,13 +47,11 @@
  #include <linux/genalloc.h>
  #include <linux/pci.h>
  #include <linux/aer.h>
+#include <linux/nmi.h>

  #include <acpi/ghes.h>
  #include <asm/apei.h>
  #include <asm/tlbflush.h>
-#ifdef CONFIG_ACPI_APEI_NMI
-#include <asm/nmi.h>
-#endif

  #include "apei-internal.h"

@@ -718,7 +716,6 @@ static int ghes_notify_sci(struct notifier_block *this,
  	return ret;
  }

-#ifdef CONFIG_ACPI_APEI_NMI
  /*
   * printk is not safe in NMI context.  So in NMI handler, we allocate
   * required memory from lock-less memory allocator
@@ -817,7 +814,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct 
pt_regs *regs)
  {
  	struct ghes *ghes, *ghes_global = NULL;
  	int sev, sev_global = -1;
-	int ret = NMI_DONE;
+	int ret = APEI_NMI_DONE;

  	BUG_ON(!IS_ENABLED(CONFIG_ACPI_APEI_NMI));

@@ -832,14 +829,14 @@ static int ghes_notify_nmi(unsigned int cmd, 
struct pt_regs *regs)
  			sev_global = sev;
  			ghes_global = ghes;
  		}
-		ret = NMI_HANDLED;
+		ret = APEI_NMI_HANDLED;
  	}

-	if (ret == NMI_DONE)
+	if (ret == APEI_NMI_DONE)
  		goto out;

  	if (sev_global >= GHES_SEV_PANIC) {
-		oops_begin();
+		arch_apei_nmi_oops_begin();
  		ghes_print_queued_estatus();
  		__ghes_print_estatus(KERN_EMERG, ghes_global->generic,
  				     ghes_global->estatus);
@@ -914,7 +911,7 @@ static int ghes_notify_init_nmi(struct ghes *ghes)
  	ghes_estatus_pool_expand(len);
  	mutex_lock(&ghes_list_mutex);
  	if (list_empty(&ghes_nmi))
-		status = register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0, "ghes");
+		status = arch_apei_register_nmi(ghes_notify_nmi, "ghes");
  	list_add_rcu(&ghes->list, &ghes_nmi);
  	mutex_unlock(&ghes_list_mutex);

@@ -928,7 +925,7 @@ static void ghes_notify_remove_nmi(struct ghes *ghes)
  	mutex_lock(&ghes_list_mutex);
  	list_del_rcu(&ghes->list);
  	if (list_empty(&ghes_nmi))
-		unregister_nmi_handler(NMI_LOCAL, "ghes");
+		arch_apei_unregister_nmi("ghes");
  	mutex_unlock(&ghes_list_mutex);
  	/*
  	 * To synchronize with NMI handler, ghes can only be
@@ -941,17 +938,14 @@ static void ghes_notify_remove_nmi(struct ghes *ghes)

  static void ghes_init_nmi(void)
  {
+	if (!IS_ENABLED(CONFIG_ACPI_APEI_NMI))
+		return;
+
  	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
  	ghes_notify_tab[ACPI_HEST_NOTIFY_NMI].init_call = ghes_notify_init_nmi;
  	ghes_notify_tab[ACPI_HEST_NOTIFY_NMI].remove_call =
  							ghes_notify_remove_nmi;
  }
-#else
-static inline void ghes_init_nmi(void)
-{
-
-}
-#endif

  static int ghes_notify_init_polled(struct ghes *ghes)
  {
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 084b4c5..1aa351c 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -56,4 +56,19 @@ extern int proc_dowatchdog(struct ctl_table *, int ,
  			   void __user *, size_t *, loff_t *);
  #endif

+#define APEI_NMI_DONE		0
+#define APEI_NMI_HANDLED	1
+
+#ifdef CONFIG_ACPI_APEI_NMI
+#include <asm/nmi.h>
+#define arch_apei_nmi_oops_begin()	oops_begin()
+#else
+#define arch_apei_register_nmi(fn, n) ({		\
+	void __attribute__((unused)) *dummy = fn;	\
+	(-ENOSYS);					\
+});
+#define arch_apei_unregister_nmi(n)
+#define arch_apei_nmi_oops_begin()
+#endif /* CONFIG_ACPI_APEI_NMI */
+
  #endif

Regards,
Tomasz
