Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab3LJCAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:00:23 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6672 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab3LJCAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:00:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 09 Dec 2013 17:53:25 -0800
Date: Mon, 9 Dec 2013 18:00:12 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
X-X-Sender: pwalmsley@tamien
To: Mikko Perttunen <mperttunen@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        =?ISO-8859-15?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Subject: [PATCH] gpu: host1x: clk_round_rate() can return a zero upon error
Message-ID: <alpine.DEB.2.02.1312091746400.4127@tamien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-669180444-1386640819=:4127"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-669180444-1386640819=:4127
Content-Type: text/plain; format=flowed; charset="ISO-8859-15"
Content-Transfer-Encoding: 8BIT


Treat both negative and zero return values from clk_round_rate() as
errors.  This is needed since subsequent patches will convert
clk_round_rate()'s return value to be an unsigned type, rather than a
signed type, since some clock sources can generate rates higher than
(2^31)-1 Hz.

Eventually, when calling clk_round_rate(), only a return value of zero
will be considered a error.  All other values will be considered valid
rates.  The comparison against values less than 0 is kept to preserve
the correct behavior in the meantime.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Terje Bergström <tbergstrom@nvidia.com>
---
Applies on v3.13-rc3.  See also:

http://marc.info/?l=linux-arm-kernel&m=138542591313620&w=2

  drivers/gpu/drm/tegra/hdmi.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index 0cd9bc2056e8..8cf9d3aeb0cd 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -959,7 +959,7 @@ static int tegra_output_hdmi_check_mode(struct tegra_output *output,
  	parent = clk_get_parent(hdmi->clk_parent);

  	err = clk_round_rate(parent, pclk * 4);
-	if (err < 0)
+	if (err <= 0)
  		*status = MODE_NOCLOCK;
  	else
  		*status = MODE_OK;
--8323329-669180444-1386640819=:4127--
