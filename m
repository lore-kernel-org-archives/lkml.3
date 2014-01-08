Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbaAHRbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:31:42 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:15166 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756136AbaAHRbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:31:38 -0500
Message-ID: <1389202297.23721.33.camel@hornet>
Subject: Re: [RFC 07/18] regmap: debugfs: Always create "registers" &
 "access" files
From: Pawel Moll <pawel.moll@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 08 Jan 2014 17:31:37 +0000
In-Reply-To: <20131224121912.GX30815@sirena.org.uk>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
	 <1387815830-8794-8-git-send-email-pawel.moll@arm.com>
	 <20131224121912.GX30815@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-24 at 12:19 +0000, Mark Brown wrote:
> On Mon, Dec 23, 2013 at 04:23:39PM +0000, Pawel Moll wrote:
> > When a map covers a single register, max_register is equal
> > to 0, so the "registers" & "access" files were not created.
> > 
> > This patch is removing this restriction. It should be save,
> > as the maps not without register 0 should return false
> > for regmap_readable(map, 0).
> 
> No, we need to find a better way of doing this such as checking to see
> if register zero is accessible in some way.  We want to avoid having
> those files if there's no way of populating them since this is useful
> information for tooling.

Something like this then?

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index c5471cd..45d812c 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -511,7 +511,7 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 	debugfs_create_file("range", 0400, map->debugfs,
 			    map, &regmap_reg_ranges_fops);
 
-	if (map->max_register) {
+	if (map->max_register || regmap_readable(map, 0)) {
 		debugfs_create_file("registers", 0400, map->debugfs,
 				    map, &regmap_map_fops);
 		debugfs_create_file("access", 0400, map->debugfs,

Other possibility would be replacing max_register with registers_num,
but it looks a massive job...

Paweł

