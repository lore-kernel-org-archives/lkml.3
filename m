Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaKJPOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:14:23 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46614 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaKJPOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:14:22 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: john.stultz@linaro.org, cbou@mail.ru, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] test_power: don't access invalid memory on empty map keys
Date: Mon, 10 Nov 2014 10:13:41 -0500
Message-Id: <1415632421-7577-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When providing an empty key to map_get_value() we'd access invalid memory
because the function assumed there would at least be one character total
in the string.

Passing an empty string would access and could possibly overwrite the byte
right before the key string.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/power/test_power.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/power/test_power.c b/drivers/power/test_power.c
index 0152f35..b47bd17 100644
--- a/drivers/power/test_power.c
+++ b/drivers/power/test_power.c
@@ -275,6 +275,8 @@ static int map_get_value(struct battery_property_map *map, const char *key,
 	buf[MAX_KEYLENGTH-1] = '\0';
 
 	cr = strnlen(buf, MAX_KEYLENGTH) - 1;
+	if (cr < 0)
+		return def_val;
 	if (buf[cr] == '\n')
 		buf[cr] = '\0';
 
-- 
1.7.10.4

