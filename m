Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab3DBWmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:42:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761784Ab3DBWM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russ Dill <Russ.Dill@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 096/124] regulator: Fix memory garbage dev_err printout.
Date: Tue,  2 Apr 2013 15:11:18 -0700
Message-Id: <20130402221115.234435578@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russ Dill <Russ.Dill@ti.com>

commit 9c7b4e8a8ad2624106fbf690fa97ab9c8c9bfa88 upstream.

commit dd8004af: 'regulator: core: Log when a device causes a voltage
constraint fail', tried to print out some information about the
check consumer min/max uV fixup, however, it uses a garbage pointer
left over from list_for_each_entry leading to boot messages in the
form:

'[    2.079890] <RANDOM ASCII>: Restricting voltage, 3735899821-4294967295uV'

Because it references regulator->dev, it could potentially read memory from
anywhere causing a panic.

This patch instead uses rdev and the updated min/max uV values.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -200,8 +200,8 @@ static int regulator_check_consumers(str
 	}
 
 	if (*min_uV > *max_uV) {
-		dev_err(regulator->dev, "Restricting voltage, %u-%uuV\n",
-			regulator->min_uV, regulator->max_uV);
+		rdev_err(rdev, "Restricting voltage, %u-%uuV\n",
+			*min_uV, *max_uV);
 		return -EINVAL;
 	}
 


