Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161325Ab3DGCgJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 22:36:09 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:36394 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161269Ab3DGCgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 22:36:06 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/3] backports: adds regulator and media susbsystems
Date: Sat,  6 Apr 2013 19:35:35 -0700
Message-Id: <1365302138-19736-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This is just test work I've been doing on the side, that really
just started from scratching an itch to see what is possible.
In the compat-drivers trees I had actually gotten to run time
test the USB video camera driver and that worked fine. Under
the new backports tree we are encouraged to just backport the
entire subsystem so I gave that a shot and this is where I got
up to. It turned out a few drivers required mucking with the
regulator and as I started backporting some functionality I
realized that the 3.2 regulator was just stubs so ended up trying
to port all of the regulator and its drivers as well.

The media drivers should now compile *if* we fix the regulator
issues but as it turns out the last issues I ran into hit a gcc
segfault :)

These patches depend on the other 9 patches I just posted. I hadn't
tested ckmake yet with the other patches...

Note one thing I realize from this exercise is that it'd be nice
to be able to rename the upstream target file when being sucked
into compat as part of compat-y or perhaps its best to do this
always with a _backport prefix ? See core.c from regulator and
how it gets pulled into compat/

I do realize that porting the regulator code may not make make sense
and if so then perhaps any media drivers that rely on it shoud likley
not be ported... But that sounds like a cheap "solution". For mobile
for example I do envision it being desirable to port over any media
or regulator drivers. One possibility I have only been toying with
in thought has been using ksplice... but that seems a bit over kill
and likely very fragile for adding new symbols. Can we extend a kernel
with backport ELF sections ? If so so, we don't necessarily need to
have the functionality to patch a kernel and keep it running at runtime
but *if* this is possible perhaps that may allow for us to add our own
sections to call on the kernel. The only issue with that of course is
that then compat-y as a whole would need to be thrown in there.

  CC [M]  /home/mcgrof/tmp/build/compat/main.o
  CC [M]  /home/mcgrof/tmp/build/compat/compat-3.3.o
  CC [M]  /home/mcgrof/tmp/build/compat/compat-3.4.o
  CC [M]  /home/mcgrof/tmp/build/compat/compat-3.5.o
  CC [M]  /home/mcgrof/tmp/build/compat/user_namespace.o
  CC [M]  /home/mcgrof/tmp/build/compat/compat-3.6.o
  CC [M]  /home/mcgrof/tmp/build/compat/compat-3.7.o
  CC [M]  /home/mcgrof/tmp/build/compat/compat-3.8.o
  CC [M]  /home/mcgrof/tmp/build/compat/compat-3.9.o
  CC [M]  /home/mcgrof/tmp/build/compat/core.o
Segmentation fault
make[8]: *** [/home/mcgrof/tmp/build/compat/core.o] Error 139

Luis R. Rodriguez (3):
  compat: redefine core_initcall() and late_initcall()
  backports: add support for voltage / current regulator subsystem
  backports: add media subsystem drivers

 .blacklist.map                                     |    9 +
 backport/Makefile.kernel                           |    8 +
 backport/Makefile.real                             |    1 +
 backport/compat/Kconfig                            |   18 +
 backport/compat/main.c                             |    5 +
 backport/defconfigs/media                          |  506 ++++++++++++++++++++
 backport/defconfigs/regulator                      |   63 +++
 backport/include/linux/compat-2.6.h                |   15 +
 backport/include/linux/compat-3.3.h                |    8 +
 copy-list                                          |   44 ++
 dependencies                                       |    6 +
 lib/blacklist.sh                                   |   35 ++
 .../media/0001-media_entity_info.patch             |   67 +++
 .../regulator/0001-disable-ftrace.patch            |   74 +++
 14 files changed, 859 insertions(+)
 create mode 100644 .blacklist.map
 create mode 100644 backport/defconfigs/media
 create mode 100644 backport/defconfigs/regulator
 create mode 100755 lib/blacklist.sh
 create mode 100644 patches/collateral-evolutions/media/0001-media_entity_info.patch
 create mode 100644 patches/collateral-evolutions/regulator/0001-disable-ftrace.patch

-- 
1.7.10.4

