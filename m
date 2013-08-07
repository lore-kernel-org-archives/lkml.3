Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab3HGHwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:52:10 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:60656 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab3HGHwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:52:07 -0400
Message-ID: <5201FCA4.30804@gmail.com>
Date: Wed, 07 Aug 2013 09:52:04 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Tom Gundersen <teg@jklm.no>, Bryan Kadzban <bryan@kadzban.is-a-geek.net>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-hotplug@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] udev: fail firmware loading immediately if no search path
 is defined
References: <CALCETrXSnFPFVPkXHwz+FFA3=+pmz9V=cMHWwtN+jG1QJALWSQ@mail.gmail.com> <325b19bb936d7ebae11edad86aac8f0931e8abd9.1375719828.git.luto@amacapital.net> <5200B1BD.7030307@gmail.com> <CAG-2HqXEj06JbUOWee=NfuRXxL75uRf=55FZcXRLHroDzYUthQ@mail.gmail.com> <CAG-2HqVvoQK8ggErGGinO9i8Pbu-O-X=eYFW445ce24dpt7HyA@mail.gmail.com> <20130806163158.GA23093@kadzban.is-a-geek.net> <CAG-2HqU=yyxomNTg9-2+bxMKP=e5_pdVT7bhB_CHhFzB-ac_mQ@mail.gmail.com> <CALCETrU-CWuefE5XUpC=xFuCXaL56Cox95nL35Bm9jMi_B+6_A@mail.gmail.com>
In-Reply-To: <CALCETrU-CWuefE5XUpC=xFuCXaL56Cox95nL35Bm9jMi_B+6_A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 07-08-13 02:26, Andy Lutomirski schreef:
> On Tue, Aug 6, 2013 at 5:24 PM, Tom Gundersen <teg@jklm.no> wrote:
>> On 6 Aug 2013 18:32, "Bryan Kadzban" <bryan@kadzban.is-a-geek.net> wrote:
>>> On Tue, Aug 06, 2013 at 11:17:17AM +0200, Tom Gundersen wrote:
>>>> On Tue, Aug 6, 2013 at 11:11 AM, Tom Gundersen <teg@jklm.no> wrote:
>>>>> On Tue, Aug 6, 2013 at 10:20 AM, Maarten Lankhorst
>>>>> <m.b.lankhorst@gmail.com> wrote:
>>>>>> Op 05-08-13 18:29, Andy Lutomirski schreef:
>>>>>>> The systemd commit below can delay firmware loading by multiple
>>>>>>> minutes if CONFIG_FW_LOADER_USER_HELPER=y.  Unfortunately no one
>>>>>>> noticed that the systemd-udev change would break new kernels as well
>>>>>>> as old kernels.
>>>>>>>
>>>>>>> Since the kernel apparently can't count on reasonable userspace
>>>>>>> support, turn this thing off by default.
>>>>>>>
>>>>>>> commit a3bd8447be4ea2ce230eb8ae0e815c04d85fa15a
>>>>>>> Author: Tom Gundersen <teg@jklm.no>
>>>>>>> Date:   Mon Mar 18 15:12:18 2013 +0100
>>>>>>>
>>>>>>>     udev: make firmware loading optional and disable by default
>>>>>>>
>>>>>>>     Distros that whish to support old kernels should set
>>>>>>>
>>>>>>> --with-firmware-dirs="/usr/lib/firmware/updates:/usr/lib/firmware"
>>>>>>>     to retain the old behaviour.
>>>>>>>
>>>>>> methinks this patch should be reverted then,
>>>>> Well, all the code is still there, so it can be enabled if anyone
>>>>> wants it.
>>>>>
>>>>>> or a stub should be added to udev to always fail firmware loading so
>>>>>> timeouts don't occur.
>>>>> I think the only use (if any) of a userspace firmware loader would be
>>>>> for anyone who wants a custom one (i.e., not udev), so we shouldn't
>>>>> just fail the loading from udev unconditionally.
>>>>>
>>>>> How about we just improve the udev documentation a bit, similar to
>>>>> Andy's kernel patch?
>>>> Sorry, I should first have checked. We already document this in the
>>>> README:
>>>>
>>>>>        Userspace firmware loading is deprecated, will go away, and
>>>>>        sometimes causes problems:
>>>>>          CONFIG_FW_LOADER_USER_HELPER=n
>>> ...And this patch is making the kernel default to the correct behavior,
>>> instead of the now-broken-by-udev behavior.
>>>
>>> I'm not sure I see the issue with it?  :-)
>> Oh yeah this patch is totally the right thing to do, I was just arguing that
>> there is nothing to be done on the udev side.
>>
>>> (Add me to the list of people that think udev is broken too, fwiw.  But
>>> let's at least not leave *both* sides in a broken-by-default state.)
>> Well I don't think it is too much to ask that the kernel and udev should be
>> configured in a consistent way. Especially as thing still work even if you
>> get it wrong, albeit with a delay.
> Except that the current defaults are inconsistent and there is no
> explanation anywhere in the logs when this is screwed up.
>
So what is wrong with my 'fail in udev immediately if not configured' idea? In that case it
doesn't matter whether CONFIG_FW_LOADER_USER_HELPER is set or not.

You could even print a useful message for the user in udev to the log, so they have an idea of what
happened. Breaking udev on older still supported kernels by default without printing any debug info
is silly, and the only cost is a small increase in disk space when unused. I did so in below patch.

~Maarten

I converted < ELEMENTSOF to != ELEMENTSOF in the loop to work correctly when the array is empty.
Most code in udev-builtin-firmware is eliminated at -O2 optimization level when FIRMWARE_PATH
is not explicitly set.

8<----
diff --git a/Makefile.am b/Makefile.am
index b8b8d06..2097629 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2235,6 +2235,7 @@ libudev_core_la_SOURCES = \
 	src/udev/udev-ctrl.c \
 	src/udev/udev-builtin.c \
 	src/udev/udev-builtin-btrfs.c \
+	src/udev/udev-builtin-firmware.c \
 	src/udev/udev-builtin-hwdb.c \
 	src/udev/udev-builtin-input_id.c \
 	src/udev/udev-builtin-keyboard.c \
@@ -2271,14 +2272,6 @@ libudev_core_la_CPPFLAGS = \
 	$(AM_CPPFLAGS) \
 	-DFIRMWARE_PATH="$(FIRMWARE_PATH)"
 
-if ENABLE_FIRMWARE
-libudev_core_la_SOURCES += \
-	src/udev/udev-builtin-firmware.c
-
-dist_udevrules_DATA += \
-	rules/50-firmware.rules
-endif
-
 if HAVE_KMOD
 libudev_core_la_SOURCES += \
 	src/udev/udev-builtin-kmod.c
diff --git a/configure.ac b/configure.ac
index 0ecc716..dc7a3e3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -823,8 +823,6 @@ for i in $with_firmware_path; do
 done
 IFS=$OLD_IFS
 AC_SUBST(FIRMWARE_PATH)
-AS_IF([test "x${FIRMWARE_PATH}" != "x"], [ AC_DEFINE(HAVE_FIRMWARE, 1, [Define if FIRMWARE is available]) ])
-AM_CONDITIONAL(ENABLE_FIRMWARE, [test "x${FIRMWARE_PATH}" != "x"])
 
 # ------------------------------------------------------------------------------
 AC_ARG_ENABLE([gudev],
diff --git a/rules/50-firmware.rules b/rules/50-firmware.rules
deleted file mode 100644
index f0ae684..0000000
--- a/rules/50-firmware.rules
+++ /dev/null
@@ -1,3 +0,0 @@
-# do not edit this file, it will be overwritten on update
-
-SUBSYSTEM=="firmware", ACTION=="add", RUN{builtin}="firmware"
diff --git a/rules/50-udev-default.rules b/rules/50-udev-default.rules
index f764789..645830e 100644
--- a/rules/50-udev-default.rules
+++ b/rules/50-udev-default.rules
@@ -8,6 +8,7 @@ SUBSYSTEM=="rtc", KERNEL=="rtc0", SYMLINK+="rtc", OPTIONS+="link_priority=-100"
 
 SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", IMPORT{builtin}="usb_id", IMPORT{builtin}="hwdb --subsystem=usb"
 SUBSYSTEM=="input", ENV{ID_INPUT}=="", IMPORT{builtin}="input_id"
+SUBSYSTEM=="firmware", ACTION=="add", IMPORT{builtin}="firmware"
 ENV{MODALIAS}!="", IMPORT{builtin}="hwdb --subsystem=$env{SUBSYSTEM}"
 
 ACTION!="add", GOTO="default_permissions_end"
diff --git a/shell-completion/bash/udevadm b/shell-completion/bash/udevadm
index 8ad8550..c22a3e2 100644
--- a/shell-completion/bash/udevadm
+++ b/shell-completion/bash/udevadm
@@ -83,7 +83,7 @@ _udevadm() {
                         fi
                         ;;
                 'test-builtin')
-                        comps='blkid btrfs hwdb input_id keyboard kmod net_id path_id usb_id uaccess'
+                        comps='blkid btrfs firmware hwdb input_id keyboard kmod net_id path_id usb_id uaccess'
                         ;;
                 *)
                         comps=${VERBS[*]}
diff --git a/src/udev/udev-builtin-firmware.c b/src/udev/udev-builtin-firmware.c
index b80940b..e678545 100644
--- a/src/udev/udev-builtin-firmware.c
+++ b/src/udev/udev-builtin-firmware.c
@@ -97,7 +97,7 @@ static int builtin_firmware(struct udev_device *dev, int argc, char *argv[], boo
 
         /* lookup firmware file */
         uname(&kernel);
-        for (i = 0; i < ELEMENTSOF(searchpath); i++) {
+        for (i = 0; i != ELEMENTSOF(searchpath); i++) {
                 strscpyl(fwpath, sizeof(fwpath), searchpath[i], kernel.release, "/", firmware, NULL);
                 fwfile = fopen(fwpath, "re");
                 if (fwfile != NULL)
@@ -112,7 +112,10 @@ static int builtin_firmware(struct udev_device *dev, int argc, char *argv[], boo
         strscpyl(loadpath, sizeof(loadpath), udev_device_get_syspath(dev), "/loading", NULL);
 
         if (fwfile == NULL) {
-                log_debug("did not find firmware file '%s'\n", firmware);
+                if (ELEMENTSOF(searchpath))
+                    log_debug("did not find firmware file '%s'\n", firmware);
+                else
+                    log_error("could not load firmware file '%s', firmware loading not enabled\n", firmware);
                 rc = EXIT_FAILURE;
                 /*
                  * Do not cancel the request in the initrd, the real root might have
diff --git a/src/udev/udev-builtin.c b/src/udev/udev-builtin.c
index 6b3a518..5a5cb30 100644
--- a/src/udev/udev-builtin.c
+++ b/src/udev/udev-builtin.c
@@ -34,9 +34,7 @@ static const struct udev_builtin *builtins[] = {
         [UDEV_BUILTIN_BLKID] = &udev_builtin_blkid,
 #endif
         [UDEV_BUILTIN_BTRFS] = &udev_builtin_btrfs,
-#ifdef HAVE_FIRMWARE
         [UDEV_BUILTIN_FIRMWARE] = &udev_builtin_firmware,
-#endif
         [UDEV_BUILTIN_HWDB] = &udev_builtin_hwdb,
         [UDEV_BUILTIN_INPUT_ID] = &udev_builtin_input_id,
         [UDEV_BUILTIN_KEYBOARD] = &udev_builtin_keyboard,
diff --git a/src/udev/udev.h b/src/udev/udev.h
index 8395926..31fa606 100644
--- a/src/udev/udev.h
+++ b/src/udev/udev.h
@@ -140,9 +140,7 @@ enum udev_builtin_cmd {
         UDEV_BUILTIN_BLKID,
 #endif
         UDEV_BUILTIN_BTRFS,
-#ifdef HAVE_FIRMWARE
         UDEV_BUILTIN_FIRMWARE,
-#endif
         UDEV_BUILTIN_HWDB,
         UDEV_BUILTIN_INPUT_ID,
         UDEV_BUILTIN_KEYBOARD,
@@ -170,9 +168,7 @@ struct udev_builtin {
 extern const struct udev_builtin udev_builtin_blkid;
 #endif
 extern const struct udev_builtin udev_builtin_btrfs;
-#ifdef HAVE_FIRMWARE
 extern const struct udev_builtin udev_builtin_firmware;
-#endif
 extern const struct udev_builtin udev_builtin_hwdb;
 extern const struct udev_builtin udev_builtin_input_id;
 extern const struct udev_builtin udev_builtin_keyboard;
diff --git a/src/udev/udevd.c b/src/udev/udevd.c
index 45ec3d6..e27a33a 100644
--- a/src/udev/udevd.c
+++ b/src/udev/udevd.c
@@ -98,9 +98,7 @@ struct event {
         dev_t devnum;
         int ifindex;
         bool is_block;
-#ifdef HAVE_FIRMWARE
         bool nodelay;
-#endif
 };
 
 static inline struct event *node_to_event(struct udev_list_node *node)
@@ -444,10 +442,8 @@ static int event_queue_insert(struct udev_device *dev)
         event->devnum = udev_device_get_devnum(dev);
         event->is_block = streq("block", udev_device_get_subsystem(dev));
         event->ifindex = udev_device_get_ifindex(dev);
-#ifdef HAVE_FIRMWARE
         if (streq(udev_device_get_subsystem(dev), "firmware"))
                 event->nodelay = true;
-#endif
 
         udev_queue_export_device_queued(udev_queue_export, dev);
         log_debug("seq %llu queued, '%s' '%s'\n", udev_device_get_seqnum(dev),
@@ -527,11 +523,9 @@ static bool is_devpath_busy(struct event *event)
                         return true;
                 }
 
-#ifdef HAVE_FIRMWARE
                 /* allow to bypass the dependency tracking */
                 if (event->nodelay)
                         continue;
-#endif
 
                 /* parent device event found */
                 if (event->devpath[common] == '/') {

