Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaICDPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:15:24 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:21581
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753968AbaICDPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:15:19 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <perex@perex.cz>, <lgirdwood@gmail.com>,
        <tiwai@suse.de>, <moinejf@free.fr>, <andrew@lunn.ch>,
        <kuninori.morimoto.gx@renesas.com>, <jsarha@ti.com>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 3/3] ASoC: simple-card: binding: update binding to support the new style.
Date: Wed, 3 Sep 2014 10:23:41 +0800
Message-ID: <1409711021-19277-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1409711021-19277-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409711021-19277-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(62966002)(64706001)(50986999)(47776003)(87286001)(80022001)(4396001)(50226001)(85306004)(99396002)(50466002)(90102001)(86362001)(21056001)(76176999)(93916002)(68736004)(81542001)(97736001)(69596002)(83322001)(6806004)(44976005)(20776003)(19580405001)(19580395003)(84676001)(89996001)(88136002)(92566001)(2201001)(92726001)(83072002)(85852003)(26826002)(74662001)(74502001)(31966008)(87936001)(81156004)(76482001)(104016003)(107046002)(95666004)(79102001)(106466001)(36756003)(104166001)(102836001)(77156001)(46102001)(77982001)(81342001)(48376002)(105606002)(229853001)(921003)(1121002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0612;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 032334F434
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update patch will split the DT node into old style and new style:
The new style will will be easier to add muti DAI links from old single
DAI link DTs.

This patch will maintian compatibility with the old DTs.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../devicetree/bindings/sound/simple-card.txt      | 183 ++++++++++++++-------
 1 file changed, 125 insertions(+), 58 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/simple-card.txt b/Documentation/devicetree/bindings/sound/simple-card.txt
index c2e9841..8c1bd30 100644
--- a/Documentation/devicetree/bindings/sound/simple-card.txt
+++ b/Documentation/devicetree/bindings/sound/simple-card.txt
@@ -1,15 +1,19 @@
-Simple-Card:
+Device-Tree bindings for Simple Card
 
 Simple-Card specifies audio DAI connections of SoC <-> codec.
 
-Required properties:
+=== Top level's properties and subnodes ===
 
+*** Required properties ***
 - compatible				: "simple-audio-card"
 
-Optional properties:
-
+*** Optional properties ***
 - simple-audio-card,name		: User specified audio sound card name, one string
 					  property.
+- simple-audio-card,format		: CPU/CODEC common audio format.
+					  "i2s", "right_j", "left_j" , "dsp_a"
+					  "dsp_b", "ac97", "pdm", "msb", "lsb"
+					  (This is used for single DAI link & old style.)
 - simple-audio-card,widgets		: Please refer to widgets.txt.
 - simple-audio-card,routing		: A list of the connections between audio components.
 					  Each entry is a pair of strings, the first being the
@@ -17,63 +21,85 @@ Optional properties:
 					  source.
 - simple-audio-card,mclk-fs             : Multiplication factor between stream rate and codec
   					  mclk.
-
-Optional subnodes:
-
-- simple-audio-card,dai-link		: Container for dai-link level
-					  properties and the CPU and CODEC
-					  sub-nodes. This container may be
-					  omitted when the card has only one
-					  DAI link. See the examples and the
-					  section bellow.
-
-Dai-link subnode properties and subnodes:
-
-If dai-link subnode is omitted and the subnode properties are directly
-under "sound"-node the subnode property and subnode names have to be
-prefixed with "simple-audio-card,"-prefix.
-
-Required dai-link subnodes:
-
-- cpu					: CPU   sub-node
-- codec					: CODEC sub-node
-
-Optional dai-link subnode properties:
-
+- simple-audio-card,frame-master	: Indicates DAI link frame master. One phandle to a cpu
+					  or codec subnode.
+					  (This is used for single DAI link & old style.)
+- simple-audio-card,bitclock-master	: Indicates DAI link bit clock master. One phandle to a
+					  cpu or codec subnode.
+					  (This is used for single DAI link & old style.)
+
+*** Optional subnodes ***
+- simple-audio-card,dai-link		: Container for DAI link level properties and the CPU
+					  and CODEC sub-nodes. This container may be omitted
+					  when the card has only one DAI link and using the old
+					  style. See the examples and the section bellow.
+- simple-audio-card,cpu			: CPU DAI sub-node.
+					  (This is used for single DAI link & old style.)
+- simple-audio-card,codec		: CODEC DAI sub-node.
+					  (This is used for single DAI link & old style.)
+
+=== DAI link node's properties and its subnodes ===
+
+*** Required subnodes ***
+- cpu					: CPU DAI sub-node
+- codec					: CODEC DAI sub-node
+
+*** Optional properties ***
 - format				: CPU/CODEC common audio format.
 					  "i2s", "right_j", "left_j" , "dsp_a"
 					  "dsp_b", "ac97", "pdm", "msb", "lsb"
-- frame-master				: Indicates dai-link frame master.
-					  phandle to a cpu or codec subnode.
-- bitclock-master			: Indicates dai-link bit clock master.
-					  phandle to a cpu or codec subnode.
-- bitclock-inversion			: bool property. Add this if the
-					  dai-link uses bit clock inversion.
-- frame-inversion			: bool property. Add this if the
-					  dai-link uses frame clock inversion.
+- frame-master				: Indicates DAI link frame master. One phandle to a cpu
+					  or codec subnode.
+					  (This is One boolean property for old style.)
+- bitclock-master			: Indicates DAI link bit clock master. One phandle to a
+					  cpu or codec subnode.
+					  (This is one boolean property for old style.)
 
 For backward compatibility the frame-master and bitclock-master
 properties can be used as booleans in codec subnode to indicate if the
-codec is the dai-link frame or bit clock master. In this case there
-should be no dai-link node, the same properties should not be present
+codec is the DAI link frame or bit clock master. In this case there
+should be no DAI link node, the same properties should not be present
 at sound-node level, and the bitclock-inversion and frame-inversion
 properties should also be placed in the codec node if needed.
 
-Required CPU/CODEC subnodes properties:
 
-- sound-dai				: phandle and port of CPU/CODEC
+=== CPU/CODEC DAI node's properties and its subnodes ===
 
-Optional CPU/CODEC subnodes properties:
+*** Required properties ***
+- sound-dai				: One phandle and port of CPU/CODEC
 
+*** Optional properties ***
+- bitclock-inversion			: Boolean property. Add this if the DAI device uses bit
+					  clock inversion.
+- frame-inversion			: Boolean property. Add this if the DAI device uses frame
+					  clock inversion.
 - dai-tdm-slot-num			: Please refer to tdm-slot.txt.
 - dai-tdm-slot-width			: Please refer to tdm-slot.txt.
-- clocks / system-clock-frequency	: specify subnode's clock if needed.
-					  it can be specified via "clocks" if system has
-					  clock node (= common clock), or "system-clock-frequency"
-					  (if system doens't support common clock)
+- clocks / system-clock-frequency	: specify CPU/CODEC DAI node's clock if needed. It can be
+					  specified via "clocks" if system has clock node
+					  (= common clock), or "system-clock-frequency"(if system
+					  doens't support common clock)
 
-Example 1 - single DAI link:
+=== Examples ===
+*** CPU & CODEC DAI DT nodes ***
+&i2c0 {
+	ak4648: ak4648@12 {
+		#sound-dai-cells = <0>;
+		compatible = "asahi-kasei,ak4648";
+		reg = <0x12>;
+	};
+};
 
+sh_fsi2: sh_fsi2@ec230000 {
+	#sound-dai-cells = <1>;
+	compatible = "renesas,sh_fsi2";
+	reg = <0xec230000 0x400>;
+	interrupt-parent = <&gic>;
+	interrupts = <0 146 0x4>;
+};
+
+Example 1 - single DAI link & old style:
+bitclock-master and frame-master as phandles.
 sound {
 	compatible = "simple-audio-card";
 	simple-audio-card,name = "VF610-Tower-Sound-Card";
@@ -91,6 +117,7 @@ sound {
 
 	simple-audio-card,cpu {
 		sound-dai = <&sh_fsi2 0>;
+		bitclock-inversion;
 	};
 
 	dailink0_master: simple-audio-card,codec {
@@ -99,24 +126,64 @@ sound {
 	};
 };
 
-&i2c0 {
-	ak4648: ak4648@12 {
-		#sound-dai-cells = <0>;
-		compatible = "asahi-kasei,ak4648";
-		reg = <0x12>;
+Example 2 - single DAI link & old style:
+bitclock-master and frame-master as boolean properties.
+sound {
+	compatible = "simple-audio-card";
+	simple-audio-card,name = "VF610-Tower-Sound-Card";
+	simple-audio-card,format = "left_j";
+	simple-audio-card,widgets =
+		"Microphone", "Microphone Jack",
+		"Headphone", "Headphone Jack",
+		"Speaker", "External Speaker";
+	simple-audio-card,routing =
+		"MIC_IN", "Microphone Jack",
+		"Headphone Jack", "HP_OUT",
+		"External Speaker", "LINE_OUT";
+
+	simple-audio-card,cpu {
+		sound-dai = <&sh_fsi2 0>;
 	};
-};
 
-sh_fsi2: sh_fsi2@ec230000 {
-	#sound-dai-cells = <1>;
-	compatible = "renesas,sh_fsi2";
-	reg = <0xec230000 0x400>;
-	interrupt-parent = <&gic>;
-	interrupts = <0 146 0x4>;
+	simple-audio-card,codec {
+		sound-dai = <&ak4648>;
+		clocks = <&osc>;
+		bitclock-master;
+		frame-master;
+		bitclock-inversion;
+	};
 };
 
-Example 2 - many DAI links:
+Example 3 - single DAI link & new style:
+sound {
+	compatible = "simple-audio-card";
+	simple-audio-card,name = "VF610-Tower-Sound-Card";
+	simple-audio-card,widgets =
+		"Microphone", "Microphone Jack",
+		"Headphone", "Headphone Jack",
+		"Speaker", "External Speaker";
+	simple-audio-card,routing =
+		"MIC_IN", "Microphone Jack",
+		"Headphone Jack", "HP_OUT",
+		"External Speaker", "LINE_OUT";
+
+	simple-audio-card,dai-link {
+		format = "i2s";
+		bitclock-master = <&dailink0_master>;
+		frame-master = <&dailink0_master>;
+		cpu {
+			sound-dai = <&sh_fsi2 0>;
+			frame-inversion;
+		};
+		dailink0_master: codec {
+			sound-dai = <&ak4648>;
+			clocks = <&osc>;
+			frame-inversion;
+		};
+	};
+};
 
+Example 4 - many DAI links:
 sound {
 	compatible = "simple-audio-card";
 	simple-audio-card,name = "Cubox Audio";
-- 
1.8.4

