Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650Ab3AOWw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:52:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:46752 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933617Ab3AOWwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        =?ISO-8859-15?q?Christian=20K=C3=83=C2=B6nig?= 
	<christian.koenig@amd.com>,
        Julien Cristau <jcristau@debian.org>
Subject: [ 121/171] drm/radeon: fix up pll selection on DCE5/6
Date: Tue, 15 Jan 2013 14:44:46 -0800
Message-Id: <20130115224322.082328642@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 26fe45a0a76f165425f332a5aaa298f149f9db22 upstream.

Selecting ATOM_PPLL_INVALID should be equivalent as the
DCPLL or PPLL0 are already programmed for the DISPCLK, but
the preferred method is to always specify the PLL selected.
SetPixelClock will check the parameters and skip the
programming if the PLL is already set up.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian KÃ¶nig <christian.koenig@amd.com>
Signed-off-by: Julien Cristau <jcristau@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/atombios_crtc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1533,7 +1533,11 @@ static int radeon_atom_pick_pll(struct d
 				 * crtc virtual pixel clock.
 				 */
 				if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(test_encoder))) {
-					if (ASIC_IS_DCE5(rdev) || rdev->clock.dp_extclk)
+					if (ASIC_IS_DCE5(rdev))
+						return ATOM_DCPLL;
+					else if (ASIC_IS_DCE6(rdev))
+						return ATOM_PPLL0;
+					else if (rdev->clock.dp_extclk)
 						return ATOM_PPLL_INVALID;
 				}
 			}


