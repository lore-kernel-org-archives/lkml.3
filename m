Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaKJUXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:23:12 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:12858 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526AbaKJUXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:23:10 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtwNAMAdYVRXQ4qy/2dsb2JhbABcgw6BLbgoBQF0miwCgScXAQEBAQF9hAMBBRoNLyMQUTkeGYhFAb0cj38BAQEHIoY6ilsHhEsFhjqXa4E0hwGGeIczg3s8L4JLAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Jens Axboe <axboe@kernel.dk>,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH v2 07/10 linux-next] cdrom: export sysctl code
Date: Mon, 10 Nov 2014 21:21:52 +0100
Message-Id: <1415650916-9975-8-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415650916-9975-1-git-send-email-fabf@skynet.be>
References: <1415650916-9975-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Move all sysctl operations to cdrom_sysctl
-Remove static/add extern in cdrom.h for some variables
-Prefix those variables with cdrom_ (suggested by Joe Perches)
-Fix some checkpatch warnings
-Update cdrom makefile accordingly.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/cdrom/Makefile       |   1 +
 drivers/cdrom/cdrom.c        | 367 +++----------------------------------------
 drivers/cdrom/cdrom_sysctl.c | 297 ++++++++++++++++++++++++++++++++++
 include/linux/cdrom.h        |  33 ++++
 4 files changed, 354 insertions(+), 344 deletions(-)
 create mode 100644 drivers/cdrom/cdrom_sysctl.c

diff --git a/drivers/cdrom/Makefile b/drivers/cdrom/Makefile
index 8ffde4f..53609b0 100644
--- a/drivers/cdrom/Makefile
+++ b/drivers/cdrom/Makefile
@@ -9,5 +9,6 @@ obj-$(CONFIG_BLK_DEV_IDECD)	+=              cdrom.o
 obj-$(CONFIG_BLK_DEV_SR)	+=              cdrom.o
 obj-$(CONFIG_PARIDE_PCD)	+=		cdrom.o
 obj-$(CONFIG_CDROM_PKTCDVD)	+=		cdrom.o
+obj-$(CONFIG_SYSCTL)		+=		cdrom_sysctl.o
 
 obj-$(CONFIG_GDROM)		+= gdrom.o      cdrom.o
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index a1a26d5..9b08f91 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -242,11 +242,6 @@
 
 -------------------------------------------------------------------------*/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#define REVISION "Revision: 3.20"
-#define VERSION "Id: cdrom.c 3.20 2003/12/17"
-
 /* I use an error-log mask to give fine grain control over the type of
    messages dumped to the system logs.  The available masks include: */
 #define CD_NOTHING      0x0
@@ -274,7 +269,6 @@
 #include <linux/mm.h>
 #include <linux/slab.h> 
 #include <linux/cdrom.h>
-#include <linux/sysctl.h>
 #include <linux/proc_fs.h>
 #include <linux/blkpg.h>
 #include <linux/init.h>
@@ -284,23 +278,23 @@
 #include <linux/uaccess.h>
 
 /* used to tell the module to turn on full debugging messages */
-static bool debug;
+bool cdrom_debug = false;
 /* default compatibility mode */
-static bool autoclose = true;
-static bool autoeject;
-static bool lockdoor = true;
+bool cdrom_autoclose = true;
+bool cdrom_autoeject = false;
+bool cdrom_lockdoor = true;
 /* will we ever get to use this... sigh. */
-static bool check_media_type;
+bool cdrom_check_media_type = false;
 /* automatically restart mrw format */
-static bool mrw_format_restart = true;
-module_param(debug, bool, 0);
-module_param(autoclose, bool, 0);
-module_param(autoeject, bool, 0);
-module_param(lockdoor, bool, 0);
-module_param(check_media_type, bool, 0);
-module_param(mrw_format_restart, bool, 0);
+bool cdrom_mrw_format_restart = true;
+module_param(cdrom_debug, bool, 0);
+module_param(cdrom_autoclose, bool, 0);
+module_param(cdrom_autoeject, bool, 0);
+module_param(cdrom_lockdoor, bool, 0);
+module_param(cdrom_check_media_type, bool, 0);
+module_param(cdrom_mrw_format_restart, bool, 0);
 
-static DEFINE_MUTEX(cdrom_mutex);
+DEFINE_MUTEX(cdrom_mutex);
 
 static const char * const mrw_format_status[] = {
 	"not mrw",
@@ -314,32 +308,24 @@ static const char * const mrw_address_space[] = { "DMA", "GAA" };
 #if (ERRLOGMASK != CD_NOTHING)
 #define cd_dbg(type, fmt, ...)				\
 do {							\
-	if ((ERRLOGMASK & type) || debug)		\
+	if ((ERRLOGMASK & type) || cdrom_debug)		\
 		pr_debug(fmt, ##__VA_ARGS__);		\
 } while (0)
 #else
 #define cd_dbg(type, fmt, ...)				\
 do {							\
-	if (0 && (ERRLOGMASK & type) || debug)		\
+	if (0 && (ERRLOGMASK & type) || cdrom_debug)		\
 		pr_debug(fmt, ##__VA_ARGS__);		\
 } while (0)
 #endif
 
-/* The (cdo->capability & ~cdi->mask & CDC_XXX) construct was used in
-   a lot of places. This macro makes the code more clear. */
-#define CDROM_CAN(type) (cdi->ops->capability & ~cdi->mask & (type))
-
 /*
  * Another popular OS uses 7 seconds as the hard timeout for default
  * commands, so it is a good choice for us as well.
  */
 #define CDROM_DEF_TIMEOUT	(7 * HZ)
 
-/* Not-exported routines. */
-
-static void cdrom_sysctl_register(void);
-
-static LIST_HEAD(cdrom_list);
+LIST_HEAD(cdrom_list);
 
 static int cdrom_dummy_generic_packet(struct cdrom_device_info *cdi,
 				      struct packet_command *cgc)
@@ -612,13 +598,13 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	cdo->n_minors = 0;
 	cdi->options = CDO_USE_FFLAGS;
 
-	if (autoclose && CDROM_CAN(CDC_CLOSE_TRAY))
+	if (cdrom_autoclose && CDROM_CAN(CDC_CLOSE_TRAY))
 		cdi->options |= (int) CDO_AUTO_CLOSE;
-	if (autoeject && CDROM_CAN(CDC_OPEN_TRAY))
+	if (cdrom_autoeject && CDROM_CAN(CDC_OPEN_TRAY))
 		cdi->options |= (int) CDO_AUTO_EJECT;
-	if (lockdoor)
+	if (cdrom_lockdoor)
 		cdi->options |= (int) CDO_LOCK;
-	if (check_media_type)
+	if (cdrom_check_media_type)
 		cdi->options |= (int) CDO_CHECK_TYPE;
 
 	if (CDROM_CAN(CDC_MRW_W))
@@ -809,7 +795,7 @@ static int cdrom_mrw_open_write(struct cdrom_device_info *cdi)
 	if (!di.mrw_status)
 		ret = 1;
 	else if (di.mrw_status == CDM_MRW_BGFORMAT_INACTIVE &&
-			mrw_format_restart)
+			cdrom_mrw_format_restart)
 		ret = cdrom_mrw_bgformat(cdi, 1);
 
 	return ret;
@@ -2492,8 +2478,8 @@ static int cdrom_ioctl_debug(struct cdrom_device_info *cdi,
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	debug = arg ? 1 : 0;
-	return debug;
+	cdrom_debug = arg ? 1 : 0;
+	return cdrom_debug;
 }
 
 static int cdrom_ioctl_get_capability(struct cdrom_device_info *cdi)
@@ -3406,313 +3392,6 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 }
 EXPORT_SYMBOL(cdrom_ioctl);
 
-#ifdef CONFIG_SYSCTL
-
-#define CDROM_STR_SIZE 1000
-
-static struct cdrom_sysctl_settings {
-	char	info[CDROM_STR_SIZE];	/* general info */
-	int	autoclose;		/* close tray upon mount, etc */
-	int	autoeject;		/* eject on umount */
-	int	debug;			/* turn on debugging messages */
-	int	lock;			/* lock the door on device open */
-	int	check;			/* check media type */
-} cdrom_sysctl_settings;
-
-enum cdrom_print_option {
-	CTL_NAME,
-	CTL_SPEED,
-	CTL_SLOTS,
-	CTL_CAPABILITY
-};
-
-static int cdrom_print_info(const char *header, int val, char *info,
-				int *pos, enum cdrom_print_option option)
-{
-	const int max_size = sizeof(cdrom_sysctl_settings.info);
-	struct cdrom_device_info *cdi;
-	int ret;
-
-	ret = scnprintf(info + *pos, max_size - *pos, header);
-	if (!ret)
-		return 1;
-
-	*pos += ret;
-
-	list_for_each_entry(cdi, &cdrom_list, list) {
-		switch (option) {
-		case CTL_NAME:
-			ret = scnprintf(info + *pos, max_size - *pos,
-					"\t%s", cdi->name);
-			break;
-		case CTL_SPEED:
-			ret = scnprintf(info + *pos, max_size - *pos,
-					"\t%d", cdi->speed);
-			break;
-		case CTL_SLOTS:
-			ret = scnprintf(info + *pos, max_size - *pos,
-					"\t%d", cdi->capacity);
-			break;
-		case CTL_CAPABILITY:
-			ret = scnprintf(info + *pos, max_size - *pos,
-					"\t%d", CDROM_CAN(val) != 0);
-			break;
-		default:
-			pr_info("invalid option%d\n", option);
-			return 1;
-		}
-		if (!ret)
-			return 1;
-		*pos += ret;
-	}
-
-	return 0;
-}
-
-static int cdrom_sysctl_info(struct ctl_table *ctl, int write,
-                           void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	int pos;
-	char *info = cdrom_sysctl_settings.info;
-	const int max_size = sizeof(cdrom_sysctl_settings.info);
-	
-	if (!*lenp || (*ppos && !write)) {
-		*lenp = 0;
-		return 0;
-	}
-
-	mutex_lock(&cdrom_mutex);
-
-	pos = sprintf(info, "CD-ROM information, " VERSION "\n");
-	
-	if (cdrom_print_info("\ndrive name:\t", 0, info, &pos, CTL_NAME))
-		goto done;
-	if (cdrom_print_info("\ndrive speed:\t", 0, info, &pos, CTL_SPEED))
-		goto done;
-	if (cdrom_print_info("\ndrive # of slots:", 0, info, &pos, CTL_SLOTS))
-		goto done;
-	if (cdrom_print_info("\nCan close tray:\t",
-				CDC_CLOSE_TRAY, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan open tray:\t",
-				CDC_OPEN_TRAY, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan lock tray:\t",
-				CDC_LOCK, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan change speed:",
-				CDC_SELECT_SPEED, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan select disk:",
-				CDC_SELECT_DISC, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan read multisession:",
-				CDC_MULTI_SESSION, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan read MCN:\t",
-				CDC_MCN, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nReports media changed:",
-				CDC_MEDIA_CHANGED, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan play audio:\t",
-				CDC_PLAY_AUDIO, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan write CD-R:\t",
-				CDC_CD_R, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan write CD-RW:",
-				CDC_CD_RW, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan read DVD:\t",
-				CDC_DVD, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan write DVD-R:",
-				CDC_DVD_R, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan write DVD-RAM:",
-				CDC_DVD_RAM, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan read MRW:\t",
-				CDC_MRW, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan write MRW:\t",
-				CDC_MRW_W, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (cdrom_print_info("\nCan write RAM:\t",
-				CDC_RAM, info, &pos, CTL_CAPABILITY))
-		goto done;
-	if (!scnprintf(info + pos, max_size - pos, "\n\n"))
-		goto done;
-doit:
-	mutex_unlock(&cdrom_mutex);
-	return proc_dostring(ctl, write, buffer, lenp, ppos);
-done:
-	pr_info("info buffer too small\n");
-	goto doit;
-}
-
-/* Unfortunately, per device settings are not implemented through
-   procfs/sysctl yet. When they are, this will naturally disappear. For now
-   just update all drives. Later this will become the template on which
-   new registered drives will be based. */
-static void cdrom_update_settings(void)
-{
-	struct cdrom_device_info *cdi;
-
-	mutex_lock(&cdrom_mutex);
-	list_for_each_entry(cdi, &cdrom_list, list) {
-		if (autoclose && CDROM_CAN(CDC_CLOSE_TRAY))
-			cdi->options |= CDO_AUTO_CLOSE;
-		else if (!autoclose)
-			cdi->options &= ~CDO_AUTO_CLOSE;
-		if (autoeject && CDROM_CAN(CDC_OPEN_TRAY))
-			cdi->options |= CDO_AUTO_EJECT;
-		else if (!autoeject)
-			cdi->options &= ~CDO_AUTO_EJECT;
-		if (lockdoor && CDROM_CAN(CDC_LOCK))
-			cdi->options |= CDO_LOCK;
-		else if (!lockdoor)
-			cdi->options &= ~CDO_LOCK;
-		if (check_media_type)
-			cdi->options |= CDO_CHECK_TYPE;
-		else
-			cdi->options &= ~CDO_CHECK_TYPE;
-	}
-	mutex_unlock(&cdrom_mutex);
-}
-
-static int cdrom_sysctl_handler(struct ctl_table *ctl, int write,
-				void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	int ret;
-	
-	ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
-
-	if (write) {
-	
-		/* we only care for 1 or 0. */
-		autoclose        = !!cdrom_sysctl_settings.autoclose;
-		autoeject        = !!cdrom_sysctl_settings.autoeject;
-		debug	         = !!cdrom_sysctl_settings.debug;
-		lockdoor         = !!cdrom_sysctl_settings.lock;
-		check_media_type = !!cdrom_sysctl_settings.check;
-
-		/* update the option flags according to the changes. we
-		   don't have per device options through sysctl yet,
-		   but we will have and then this will disappear. */
-		cdrom_update_settings();
-	}
-
-        return ret;
-}
-
-/* Place files in /proc/sys/dev/cdrom */
-static struct ctl_table cdrom_table[] = {
-	{
-		.procname	= "info",
-		.data		= &cdrom_sysctl_settings.info, 
-		.maxlen		= CDROM_STR_SIZE,
-		.mode		= 0444,
-		.proc_handler	= cdrom_sysctl_info,
-	},
-	{
-		.procname	= "autoclose",
-		.data		= &cdrom_sysctl_settings.autoclose,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= cdrom_sysctl_handler,
-	},
-	{
-		.procname	= "autoeject",
-		.data		= &cdrom_sysctl_settings.autoeject,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= cdrom_sysctl_handler,
-	},
-	{
-		.procname	= "debug",
-		.data		= &cdrom_sysctl_settings.debug,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= cdrom_sysctl_handler,
-	},
-	{
-		.procname	= "lock",
-		.data		= &cdrom_sysctl_settings.lock,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= cdrom_sysctl_handler,
-	},
-	{
-		.procname	= "check_media",
-		.data		= &cdrom_sysctl_settings.check,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= cdrom_sysctl_handler
-	},
-	{ }
-};
-
-static struct ctl_table cdrom_cdrom_table[] = {
-	{
-		.procname	= "cdrom",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= cdrom_table,
-	},
-	{ }
-};
-
-/* Make sure that /proc/sys/dev is there */
-static struct ctl_table cdrom_root_table[] = {
-	{
-		.procname	= "dev",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= cdrom_cdrom_table,
-	},
-	{ }
-};
-static struct ctl_table_header *cdrom_sysctl_header;
-
-static void cdrom_sysctl_register(void)
-{
-	static bool initialized;
-
-	if (initialized)
-		return;
-
-	cdrom_sysctl_header = register_sysctl_table(cdrom_root_table);
-
-	/* set the defaults */
-	cdrom_sysctl_settings.autoclose = autoclose;
-	cdrom_sysctl_settings.autoeject = autoeject;
-	cdrom_sysctl_settings.debug = debug;
-	cdrom_sysctl_settings.lock = lockdoor;
-	cdrom_sysctl_settings.check = check_media_type;
-
-	initialized = true;
-}
-
-static void cdrom_sysctl_unregister(void)
-{
-	if (cdrom_sysctl_header)
-		unregister_sysctl_table(cdrom_sysctl_header);
-}
-
-#else /* CONFIG_SYSCTL */
-
-static void cdrom_sysctl_register(void)
-{
-}
-
-static void cdrom_sysctl_unregister(void)
-{
-}
-
-#endif /* CONFIG_SYSCTL */
-
 static int __init cdrom_init(void)
 {
 	cdrom_sysctl_register();
diff --git a/drivers/cdrom/cdrom_sysctl.c b/drivers/cdrom/cdrom_sysctl.c
new file mode 100644
index 0000000..3035db3
--- /dev/null
+++ b/drivers/cdrom/cdrom_sysctl.c
@@ -0,0 +1,297 @@
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/cdrom.h>
+#include <linux/sysctl.h>
+
+#define CDROM_STR_SIZE 1000
+
+static struct cdrom_sysctl_settings {
+	char	info[CDROM_STR_SIZE];	/* general info */
+	int	autoclose;		/* close tray upon mount, etc */
+	int	autoeject;		/* eject on umount */
+	int	debug;			/* turn on debugging messages */
+	int	lock;			/* lock the door on device open */
+	int	check;			/* check media type */
+} cdrom_sysctl_settings;
+
+enum cdrom_print_option {
+	CTL_NAME,
+	CTL_SPEED,
+	CTL_SLOTS,
+	CTL_CAPABILITY
+};
+
+static int cdrom_print_info(const char *header, int val, char *info,
+				int *pos, enum cdrom_print_option option)
+{
+	const int max_size = sizeof(cdrom_sysctl_settings.info);
+	struct cdrom_device_info *cdi;
+	int ret;
+
+	ret = scnprintf(info + *pos, max_size - *pos, header);
+	if (!ret)
+		return 1;
+
+	*pos += ret;
+
+	list_for_each_entry(cdi, &cdrom_list, list) {
+		switch (option) {
+		case CTL_NAME:
+			ret = scnprintf(info + *pos, max_size - *pos,
+					"\t%s", cdi->name);
+			break;
+		case CTL_SPEED:
+			ret = scnprintf(info + *pos, max_size - *pos,
+					"\t%d", cdi->speed);
+			break;
+		case CTL_SLOTS:
+			ret = scnprintf(info + *pos, max_size - *pos,
+					"\t%d", cdi->capacity);
+			break;
+		case CTL_CAPABILITY:
+			ret = scnprintf(info + *pos, max_size - *pos,
+					"\t%d", CDROM_CAN(val) != 0);
+			break;
+		default:
+			pr_info("invalid option%d\n", option);
+			return 1;
+		}
+		if (!ret)
+			return 1;
+		*pos += ret;
+	}
+
+	return 0;
+}
+
+static int cdrom_sysctl_info(struct ctl_table *ctl, int write,
+			     void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int pos;
+	char *info = cdrom_sysctl_settings.info;
+	const int max_size = sizeof(cdrom_sysctl_settings.info);
+
+	if (!*lenp || (*ppos && !write)) {
+		*lenp = 0;
+		return 0;
+	}
+
+	mutex_lock(&cdrom_mutex);
+
+	pos = sprintf(info, "CD-ROM information, " VERSION "\n");
+
+	if (cdrom_print_info("\ndrive name:\t", 0, info, &pos, CTL_NAME))
+		goto done;
+	if (cdrom_print_info("\ndrive speed:\t", 0, info, &pos, CTL_SPEED))
+		goto done;
+	if (cdrom_print_info("\ndrive # of slots:", 0, info, &pos, CTL_SLOTS))
+		goto done;
+	if (cdrom_print_info("\nCan close tray:\t",
+				CDC_CLOSE_TRAY, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan open tray:\t",
+				CDC_OPEN_TRAY, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan lock tray:\t",
+				CDC_LOCK, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan change speed:",
+				CDC_SELECT_SPEED, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan select disk:",
+				CDC_SELECT_DISC, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan read multisession:",
+				CDC_MULTI_SESSION, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan read MCN:\t",
+				CDC_MCN, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nReports media changed:",
+				CDC_MEDIA_CHANGED, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan play audio:\t",
+				CDC_PLAY_AUDIO, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write CD-R:\t",
+				CDC_CD_R, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write CD-RW:",
+				CDC_CD_RW, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan read DVD:\t",
+				CDC_DVD, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write DVD-R:",
+				CDC_DVD_R, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write DVD-RAM:",
+				CDC_DVD_RAM, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan read MRW:\t",
+				CDC_MRW, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write MRW:\t",
+				CDC_MRW_W, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write RAM:\t",
+				CDC_RAM, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (!scnprintf(info + pos, max_size - pos, "\n\n"))
+		goto done;
+doit:
+	mutex_unlock(&cdrom_mutex);
+	return proc_dostring(ctl, write, buffer, lenp, ppos);
+done:
+	pr_info("info buffer too small\n");
+	goto doit;
+}
+
+/* Unfortunately, per device settings are not implemented through
+   procfs/sysctl yet. When they are, this will naturally disappear. For now
+   just update all drives. Later this will become the template on which
+   new registered drives will be based. */
+static void cdrom_update_settings(void)
+{
+	struct cdrom_device_info *cdi;
+
+	mutex_lock(&cdrom_mutex);
+	list_for_each_entry(cdi, &cdrom_list, list) {
+		if (cdrom_autoclose && CDROM_CAN(CDC_CLOSE_TRAY))
+			cdi->options |= CDO_AUTO_CLOSE;
+		else if (!cdrom_autoclose)
+			cdi->options &= ~CDO_AUTO_CLOSE;
+		if (cdrom_autoeject && CDROM_CAN(CDC_OPEN_TRAY))
+			cdi->options |= CDO_AUTO_EJECT;
+		else if (!cdrom_autoeject)
+			cdi->options &= ~CDO_AUTO_EJECT;
+		if (cdrom_lockdoor && CDROM_CAN(CDC_LOCK))
+			cdi->options |= CDO_LOCK;
+		else if (!cdrom_lockdoor)
+			cdi->options &= ~CDO_LOCK;
+		if (cdrom_check_media_type)
+			cdi->options |= CDO_CHECK_TYPE;
+		else
+			cdi->options &= ~CDO_CHECK_TYPE;
+	}
+	mutex_unlock(&cdrom_mutex);
+}
+
+static int cdrom_sysctl_handler(struct ctl_table *ctl, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
+
+	if (write) {
+
+		/* we only care for 1 or 0. */
+		cdrom_autoclose         = !!cdrom_sysctl_settings.autoclose;
+		cdrom_autoeject         = !!cdrom_sysctl_settings.autoeject;
+		cdrom_debug		= !!cdrom_sysctl_settings.debug;
+		cdrom_lockdoor          = !!cdrom_sysctl_settings.lock;
+		cdrom_check_media_type  = !!cdrom_sysctl_settings.check;
+
+		/* update the option flags according to the changes. we
+		   don't have per device options through sysctl yet,
+		   but we will have and then this will disappear. */
+		cdrom_update_settings();
+	}
+
+	return ret;
+}
+
+/* Place files in /proc/sys/dev/cdrom */
+static struct ctl_table cdrom_table[] = {
+	{
+		.procname	= "info",
+		.data		= &cdrom_sysctl_settings.info,
+		.maxlen		= CDROM_STR_SIZE,
+		.mode		= 0444,
+		.proc_handler	= cdrom_sysctl_info,
+	},
+	{
+		.procname	= "autoclose",
+		.data		= &cdrom_sysctl_settings.autoclose,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= cdrom_sysctl_handler,
+	},
+	{
+		.procname	= "autoeject",
+		.data		= &cdrom_sysctl_settings.autoeject,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= cdrom_sysctl_handler,
+	},
+	{
+		.procname	= "debug",
+		.data		= &cdrom_sysctl_settings.debug,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= cdrom_sysctl_handler,
+	},
+	{
+		.procname	= "lock",
+		.data		= &cdrom_sysctl_settings.lock,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= cdrom_sysctl_handler,
+	},
+	{
+		.procname	= "check_media",
+		.data		= &cdrom_sysctl_settings.check,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= cdrom_sysctl_handler
+	},
+	{ }
+};
+
+static struct ctl_table cdrom_cdrom_table[] = {
+	{
+		.procname	= "cdrom",
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= cdrom_table,
+	},
+	{ }
+};
+
+/* Make sure that /proc/sys/dev is there */
+static struct ctl_table cdrom_root_table[] = {
+	{
+		.procname	= "dev",
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= cdrom_cdrom_table,
+	},
+	{ }
+};
+static struct ctl_table_header *cdrom_sysctl_header;
+
+void cdrom_sysctl_register(void)
+{
+	static bool initialized;
+
+	if (initialized)
+		return;
+
+	cdrom_sysctl_header = register_sysctl_table(cdrom_root_table);
+
+	/* set the defaults */
+	cdrom_sysctl_settings.autoclose = cdrom_autoclose;
+	cdrom_sysctl_settings.autoeject = cdrom_autoeject;
+	cdrom_sysctl_settings.debug = cdrom_debug;
+	cdrom_sysctl_settings.lock = cdrom_lockdoor;
+	cdrom_sysctl_settings.check = cdrom_check_media_type;
+
+	initialized = true;
+}
+
+void cdrom_sysctl_unregister(void)
+{
+	if (cdrom_sysctl_header)
+		unregister_sysctl_table(cdrom_sysctl_header);
+}
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 8609d57..2c9d6fb 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -10,10 +10,23 @@
 #ifndef	_LINUX_CDROM_H
 #define	_LINUX_CDROM_H
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#define REVISION "Revision: 3.20"
+#define VERSION "Id: cdrom.c 3.20 2003/12/17"
+
 #include <linux/fs.h>		/* not really needed, later.. */
 #include <linux/list.h>
 #include <uapi/linux/cdrom.h>
 
+/* The (cdo->capability & ~cdi->mask & CDC_XXX) construct was used in
+   a lot of places. This macro makes the code more clear. */
+#define CDROM_CAN(type) (cdi->ops->capability & ~cdi->mask & (type))
+
 struct packet_command
 {
 	unsigned char 		cmd[CDROM_PACKET_SIZE];
@@ -311,4 +324,24 @@ static inline int msf_to_lba(u8 m, u8 s, u8 f)
 {
 	return (((m * CD_SECS) + s) * CD_FRAMES + f) - CD_MSF_OFFSET;
 }
+
+/* cdrom.c */
+extern bool cdrom_debug;
+extern bool cdrom_autoclose;
+extern bool cdrom_autoeject;
+extern bool cdrom_lockdoor;
+extern bool cdrom_check_media_type;
+extern bool cdrom_mrw_format_restart;
+extern struct list_head cdrom_list;
+extern struct mutex cdrom_mutex;
+
+/* cdrom_sysctl.c */
+#ifdef CONFIG_SYSCTL
+extern void cdrom_sysctl_register(void);
+extern void cdrom_sysctl_unregister(void);
+#else
+#define cdrom_sysctl_register do { } while (0)
+#define cdrom_sysctl_unregister do { } while (0)
+#endif /* CONFIG_SYSCTL */
+
 #endif  /* _LINUX_CDROM_H */
-- 
1.9.1

