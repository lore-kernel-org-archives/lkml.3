Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbaKTAH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:07:27 -0500
Received: from relay.variantweb.net ([104.131.199.242]:53870 "EHLO
	relay.variantweb.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756402AbaKTAHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:07:25 -0500
Date: Wed, 19 Nov 2014 18:07:22 -0600
From: Seth Jennings <sjennings@variantweb.net>
To: Peter Foley <pefoley2@pefoley.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: v3.18-rc5 build failure on ppc64 in Documentation/mic/mpssd/mpssd.o
Message-ID: <20141120000722.GA10693@cerebellum.variantweb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One or more in the following commit set in the 3.18 merge window is causing
build failure on ppc64 with the default config:

7b345771ba921361b318e95bf21b257c65ac141c Documentation: update include path for mpssd
8c2b0dc83d9840da4d993a5dbb15c5974ad5a188 Documentation: support glibc versions without htole macros
6ab0e475f1f38b6be90aff4ef3ebf928c4a73dc8 Documentation: fix misc. warnings
adb19fb66eeebac07fe37d968725bb8906dadb8e Documentation: add makefiles for more targets

Building v3.18-rc5 and I have glibc 2.17.

The problem is that for big endian, the htole* macros are not simple compile
time transforms by the precompiler, but rather block code that must be executed
in function context.

Build errors:
===
  HOSTCC  Documentation/mic/mpssd/mpssd.o
In file included from /usr/include/bits/byteswap.h:34:0,
                 from /usr/include/endian.h:60,
                 from /usr/include/bits/waitstatus.h:64,
                 from /usr/include/stdlib.h:42,
                 from Documentation/mic/mpssd/mpssd.c:23:
Documentation/mic/mpssd/mpssd.c:93:10: error: braced-group within expression allowed only inside a function
   .num = htole16(MIC_VRING_ENTRIES),
          ^
Documentation/mic/mpssd/mpssd.c:96:10: error: braced-group within expression allowed only inside a function
   .num = htole16(MIC_VRING_ENTRIES),
          ^
Documentation/mic/mpssd/mpssd.c:113:10: error: braced-group within expression allowed only inside a function
   .num = htole16(MIC_VRING_ENTRIES),
          ^
Documentation/mic/mpssd/mpssd.c:116:10: error: braced-group within expression allowed only inside a function
   .num = htole16(MIC_VRING_ENTRIES),
          ^
Documentation/mic/mpssd/mpssd.c:119:3: error: initializer element is not constant
   .host_features = htole32(
   ^
Documentation/mic/mpssd/mpssd.c:119:3: error: (near initialization for ‘virtnet_dev_page.host_features’)
In file included from /usr/include/bits/byteswap.h:34:0,
                 from /usr/include/endian.h:60,
                 from /usr/include/bits/waitstatus.h:64,
                 from /usr/include/stdlib.h:42,
                 from Documentation/mic/mpssd/mpssd.c:23:
Documentation/mic/mpssd/mpssd.c:146:10: error: braced-group within expression allowed only inside a function
   .num = htole16(MIC_VRING_ENTRIES),
          ^
Documentation/mic/mpssd/mpssd.c:149:3: error: initializer element is not constant
   htole32(1<<VIRTIO_BLK_F_SEG_MAX),
   ^
Documentation/mic/mpssd/mpssd.c:149:3: error: (near initialization for ‘virtblk_dev_page.host_features’)
Documentation/mic/mpssd/mpssd.c:151:3: error: initializer element is not constant
   .seg_max = htole32(MIC_VRING_ENTRIES - 2),
   ^
Documentation/mic/mpssd/mpssd.c:151:3: error: (near initialization for ‘virtblk_dev_page.blk_config.seg_max’)
Documentation/mic/mpssd/mpssd.c:152:3: error: initializer element is not constant
   .capacity = htole64(0),
   ^
Documentation/mic/mpssd/mpssd.c:152:3: error: (near initialization for ‘virtblk_dev_page.blk_config.capacity’)
make[3]: *** [Documentation/mic/mpssd/mpssd.o] Error 1
===

Reverting the commits fixes the issue, however, a more targeted approach could
just skip make on Documentation/mic/mpssd/ until the endianness issue is
resolved. Or something else...

Thanks,
Seth
