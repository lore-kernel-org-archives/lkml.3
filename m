Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbaGUPpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:45:45 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47400 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933134AbaGUPpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:45:41 -0400
Date: Mon, 21 Jul 2014 08:43:07 -0700
From: Kees Cook <kees@outflux.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, Ming Lei <ming.lei@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/7] firmware_class: add "fd" input file
Message-ID: <20140721154307.GG5412@outflux.net>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
 <1405373897-31671-7-git-send-email-keescook@chromium.org>
 <CACVXFVOnxjXjnKRWg7sv425POLSS96kAxxEohtLqj4dvcxnRyg@mail.gmail.com>
 <CAGXu5j+xx2exZdD64mXWzmvVUzBrFUOg-kZ5E4+tvKAuGTKW4w@mail.gmail.com>
 <CACVXFVMk5hTAvMgL0V2ycy-P=LCtOktimw5Hst+aFYLS6jewXw@mail.gmail.com>
 <CAGXu5jLD=9cqzV90JKEBJjwzTXVzGhz9_1nnwFCG_0zcA1TE8A@mail.gmail.com>
 <20140721152635.GB6363@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721152635.GB6363@kroah.com>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 08:26:35AM -0700, Greg Kroah-Hartman wrote:
> On Mon, Jul 21, 2014 at 08:08:16AM -0700, Kees Cook wrote:
> > Perhaps it would be easier if I also sent the patch to udev's helper,
> > so you could see how I propose handling the userspace change to using
> > the new interface?
> 
> As there is no more "udev firmware helper", I don't know what you would
> be patching here.  Firmware should always be loaded by the kernel
> directly, udev isn't involved anyore at all.
> 
> confused,
> 
> greg k-h

The kernel _can_ load directly (when the paths are configured correctly),
but I'm not sure why you say udev isn't involved any more. It's been like
this for years, and even the latest systemd shows the udev rule is still in
place:
http://cgit.freedesktop.org/systemd/systemd/tree/rules/50-firmware.rules
and that the firmware loader is still in the source tree:
http://cgit.freedesktop.org/systemd/systemd/tree/src/udev/udev-builtin-firmware.c

Here's the patch for the new interface...

-Kees

---
From: Kees Cook <keescook@chromium.org>
Date: Sun, 23 Mar 2014 07:46:07 -0700
Subject: [PATCH] firmware: use fd-based interface if available

The new kernel firmware_class interface file "fd" performs the firmware
loading in a single step, allowing the kernel to validate the firmware
origin and contents.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 src/udev/udev-builtin-firmware.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/src/udev/udev-builtin-firmware.c b/src/udev/udev-builtin-firmware.c
index 8cfeed6..893ec13 100644
--- a/src/udev/udev-builtin-firmware.c
+++ b/src/udev/udev-builtin-firmware.c
@@ -80,6 +80,7 @@ static int builtin_firmware(struct udev_device *dev, int argc, char *argv[], boo
         static const char *searchpath[] = { FIRMWARE_PATH };
         char loadpath[UTIL_PATH_SIZE];
         char datapath[UTIL_PATH_SIZE];
+        char fdpath[UTIL_PATH_SIZE];
         char fwpath[UTIL_PATH_SIZE];
         const char *firmware;
         FILE *fwfile = NULL;
@@ -131,6 +132,16 @@ static int builtin_firmware(struct udev_device *dev, int argc, char *argv[], boo
                 goto exit;
         }
 
+        /* Use fd-based firmware loading interface. */
+        strscpyl(fdpath, sizeof(fdpath), udev_device_get_syspath(dev), "/fd", NULL);
+        if (stat(fdpath, &statbuf) == 0) {
+                snprintf(datapath, sizeof(datapath), "%d", fileno(fwfile));
+                /* We're done if the we gave the kernel our fw fd. */
+                if (set_loading(udev, fdpath, (const char *)datapath))
+                        goto exit;
+        }
+
+        /* Fallback to legacy blob loading. */
         if (!set_loading(udev, loadpath, "1"))
                 goto exit;
 
-- 
1.7.9.5



-- 
Kees Cook
Chrome OS Security
