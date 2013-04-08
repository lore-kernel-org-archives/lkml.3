Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936659Ab3DHKY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:24:26 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:60726 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935425Ab3DHKYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:24:24 -0400
Message-ID: <1365416662.1830.86.camel@x61.thuisdomein>
Subject: Re: [PATCH] regmap: don't corrupt work buffer in _regmap_raw_write()
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Mon, 08 Apr 2013 12:24:22 +0200
In-Reply-To: <20130321190939.GI15926@opensource.wolfsonmicro.com>
References: <1363820522-25954-1-git-send-email-swarren@wwwdotorg.org>
	 <20130321190939.GI15926@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Apr 2013 10:24:22.0201 (UTC) FILETIME=[3C73FA90:01CE3443]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 20:09 +0100, Mark Brown wrote:
> On Wed, Mar 20, 2013 at 05:02:02PM -0600, Stephen Warren wrote:
> > _regmap_raw_write() contains code to call regcache_write() to write
> > values to the cache. That code calls memcpy() to copy the value data to
> > the start of the work_buf. However, at least when _regmap_raw_write() is
> 
> Applied, thanks.

0) This patch ended up as mainline commit
bc8ce4afd7ee7e1421c935d24b1f879f82afdd4e, which is part of v3.9-rc6.

1) Building regmap.o now triggers this warning:
    drivers/base/regmap/regmap.c: In function ‘_regmap_raw_write’:
    drivers/base/regmap/regmap.c:946:4: warning: passing argument 1 of ‘map->format.parse_val’ discards ‘const’ qualifier from pointer target type [enabled by default]
    drivers/base/regmap/regmap.c:946:4: note: expected ‘void *’ but argument is of type ‘const void *’

2) The following (draft) patch silences this warning. I'm a bit
uncertain what the regmap_parse_*() functions are meant to do. So I'd
like to first ask whether something along these lines is acceptable.


Paul Bolle

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 5a22bd3..35877b7 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -38,7 +38,7 @@ struct regmap_format {
                             unsigned int reg, unsigned int val);
        void (*format_reg)(void *buf, unsigned int reg, unsigned int shift);
        void (*format_val)(void *buf, unsigned int val, unsigned int shift);
-       unsigned int (*parse_val)(void *buf);
+       unsigned int (*parse_val)(const void *buf);
 };
 
 struct regmap_async {
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index d34adef..2ca90a6 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -228,30 +228,28 @@ static void regmap_format_32_native(void *buf, unsigned int val,
        *(u32 *)buf = val << shift;
 }
 
-static unsigned int regmap_parse_8(void *buf)
+static unsigned int regmap_parse_8(const void *buf)
 {
-       u8 *b = buf;
+       const u8 *b = buf;
 
        return b[0];
 }
 
-static unsigned int regmap_parse_16_be(void *buf)
+static unsigned int regmap_parse_16_be(const void *buf)
 {
-       __be16 *b = buf;
+       const __be16 *b = buf;
 
-       b[0] = be16_to_cpu(b[0]);
-
-       return b[0];
+       return be16_to_cpu(b[0]);
 }
 
-static unsigned int regmap_parse_16_native(void *buf)
+static unsigned int regmap_parse_16_native(const void *buf)
 {
        return *(u16 *)buf;
 }
 
-static unsigned int regmap_parse_24(void *buf)
+static unsigned int regmap_parse_24(const void *buf)
 {
-       u8 *b = buf;
+       const u8 *b = buf;
        unsigned int ret = b[2];
        ret |= ((unsigned int)b[1]) << 8;
        ret |= ((unsigned int)b[0]) << 16;
@@ -259,16 +257,14 @@ static unsigned int regmap_parse_24(void *buf)
        return ret;
 }
 
-static unsigned int regmap_parse_32_be(void *buf)
+static unsigned int regmap_parse_32_be(const void *buf)
 {
-       __be32 *b = buf;
+       const __be32 *b = buf;
 
-       b[0] = be32_to_cpu(b[0]);
-
-       return b[0];
+       return be32_to_cpu(b[0]);
 }
 
-static unsigned int regmap_parse_32_native(void *buf)
+static unsigned int regmap_parse_32_native(const void *buf)
 {
        return *(u32 *)buf;
 }


