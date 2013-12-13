Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3LMMal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 07:30:41 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:44679 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710Ab3LMMaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 07:30:39 -0500
Date: Fri, 13 Dec 2013 12:30:28 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v5 08/14] efi: export efi runtime memory mapping to sysfs
Message-ID: <20131213123028.GB18640@console-pimps.org>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-9-git-send-email-dyoung@redhat.com>
 <20131211185520.GG23793@pd.tnic>
 <20131212023617.GF3751@dhcp-16-126.nay.redhat.com>
 <20131212205346.GA30162@pd.tnic>
 <20131213072600.GB11164@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213072600.GB11164@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec, at 03:26:00PM, Dave Young wrote:
> On 12/12/13 at 09:53pm, Borislav Petkov wrote:
> > On Thu, Dec 12, 2013 at 10:36:17AM +0800, Dave Young wrote:
> > > Sorry that I forgot to explain this in changelog, should ask you before.
> > > 
> > > I did try moving it to efisubsys_init but it need add extern declaration
> > 
> > So what? Add it.
> > 
> > > for efi_runtime_map_init. Since link order will ensure it being called after
> > > efisubsys_init I think it's fine with this static function.
> > 
> > This is actually exactly the reason why it shouldn't be another
> > subsys_initcall() if it can be helped. People would need to go have a
> > look at drivers/firmware/efi/Makefile to realize that the link order is
> > ok.
> > 
> > And, this is prone to future breakage if people go and move code around
> > and thereby change the link order.
> > 
> > Please call efi_runtime_map_init from efisubsys_init.
> 
> After moving to efisubsys_init, the code will looks like below, because
> the funtion only is used in drivers/firmware/efi/efi.c thus I can not
> add a blank function in #else section in the efi.h header file. Creating
> another header file for this one function looks bad to me.

I agree with Borislav that this should be invoked from efisubsys_init().
Also Dave, there's nothing inherently x86-specific about runtime-map.c -
we've been trying not to dump arch-specific code in
drivers/firmware/efi/.

How about something like this, just to give you an idea? This would
allow the ARM/ia64 folks to enable this code if they want at some later
date. But more than that, it makes the code more self-contained and uses
some real interfaces instead of relying on global variables,

(not compile tested)

---

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 94a1cbcf6e2e..f45ea41deae0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -76,8 +76,8 @@ static __initdata efi_config_table_type_t arch_tables[] = {
 	{NULL_GUID, NULL, NULL},
 };
 
-void *efi_runtime_map;
-int nr_efi_runtime_map;
+static void *efi_runtime_map;
+static int nr_efi_runtime_map;
 static u64 efi_setup; /* efi setup_data physical address */
 
 /*
@@ -1084,6 +1084,9 @@ void __init efi_enter_virtual_mode(void)
 		}
 	}
 
+	efi_runtime_map_setup(efi_runtime_map, nr_efi_runtime_map,
+			      boot_params.efi_info.efi_memdesc_size);
+
 	BUG_ON(!efi.systab);
 
 	efi_setup_page_tables();
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 0a288e306252..9870eb55d0e5 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -38,8 +38,7 @@ struct efi __read_mostly efi = {
 };
 EXPORT_SYMBOL(efi);
 
-struct kobject *efi_kobj;
-EXPORT_SYMBOL_GPL(efi_kobj);
+static struct kobject *efi_kobj;
 static struct kobject *efivars_kobj;
 
 /*
@@ -176,6 +175,8 @@ static int __init efisubsys_init(void)
 		goto err_remove_group;
 	}
 
+	efi_runtime_map_init(efi_kobj);
+
 	return 0;
 
 err_remove_group:
diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
index e5e998494d8a..ef9631e9c03e 100644
--- a/drivers/firmware/efi/runtime-map.c
+++ b/drivers/firmware/efi/runtime-map.c
@@ -14,6 +14,10 @@
 
 #include <asm/setup.h>
 
+static void *efi_runtime_map;
+static int nr_efi_runtime_map;
+static u32 efi_memdesc_size;
+ 
 struct efi_runtime_map_entry {
 	efi_memory_desc_t md;
 	struct kobject kobj;   /* kobject for each entry */
@@ -105,7 +109,6 @@ static struct efi_runtime_map_entry *add_sysfs_runtime_map_entry(int nr)
 {
 	int ret;
 	struct efi_runtime_map_entry *entry;
-	struct efi_info *e = &boot_params.efi_info;
 
 	if (!map_kset) {
 		map_kset = kset_create_and_add("runtime-map", NULL,
@@ -120,7 +123,7 @@ static struct efi_runtime_map_entry *add_sysfs_runtime_map_entry(int nr)
 		return entry;
 	}
 
-	memcpy(&entry->md, efi_runtime_map + nr * e->efi_memdesc_size,
+	memcpy(&entry->md, efi_runtime_map + nr * efi_memdesc_size,
 	       sizeof(efi_memory_desc_t));
 
 	kobject_init(&entry->kobj, &map_ktype);
@@ -135,7 +138,14 @@ static struct efi_runtime_map_entry *add_sysfs_runtime_map_entry(int nr)
 	return entry;
 }
 
-static int __init efi_runtime_map_init(void)
+int efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size)
+{
+	efi_runtime_map = map;
+	nr_efi_runtime_map = nr_entries;
+	efi_memdesc_size = desc_size;
+}
+
+int __init efi_runtime_map_init(struct kobject *efi_kobj)
 {
 	int i, j, ret = 0;
 	struct efi_runtime_map_entry *entry;
@@ -172,5 +182,3 @@ out_add_entry:
 out:
 	return ret;
 }
-
-subsys_initcall(efi_runtime_map_init);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 4f1651d303b8..47e067044054 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -873,9 +873,8 @@ int efivars_sysfs_init(void);
 #endif /* CONFIG_EFI_VARS */
 
 #ifdef CONFIG_EFI_RUNTIME_MAP
-extern void *efi_runtime_map;
-extern int nr_efi_runtime_map;
-extern struct kobject *efi_kobj;
+int efi_runtime_map_init(struct kobject *);
+int efi_runtime_map_setup(void *, int, u32);
 #endif
 
 #endif /* _LINUX_EFI_H */

-- 
Matt Fleming, Intel Open Source Technology Center
