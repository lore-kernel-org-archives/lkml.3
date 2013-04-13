Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3DMOOY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 10:14:24 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64842 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab3DMOOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 10:14:18 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: backports@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 6/7] backports: add media subsystem drivers
Date: Sat, 13 Apr 2013 07:13:43 -0700
Message-Id: <1365862424-6530-7-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365862424-6530-1-git-send-email-mcgrof@do-not-panic.com>
References: <1365862424-6530-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This adds backport support for all media subsystem
drivers. This is enabled only for >= 3.2. Some media
drivers rely on the new probe deferrral mechanism
(-EPROBE_DEFER see commit d1c3414c), those are only
enabled for kernels >= 3.4. Some media drivers only
depend on the regulatory but since we only support
backporting the regulatory on kernels >= 3.4 we only
enable those media drivers for >= 3.4.

This backports 433 media drivers.

1   2.6.24              [  OK  ]
2   2.6.25              [  OK  ]
3   2.6.26              [  OK  ]
4   2.6.27              [  OK  ]
5   2.6.28              [  OK  ]
6   2.6.29              [  OK  ]
7   2.6.30              [  OK  ]
8   2.6.31              [  OK  ]
9   2.6.32              [  OK  ]
10  2.6.33              [  OK  ]
11  2.6.34              [  OK  ]
12  2.6.35              [  OK  ]
13  2.6.36              [  OK  ]
14  2.6.37              [  OK  ]
15  2.6.38              [  OK  ]
16  2.6.39              [  OK  ]
17  3.0.65              [  OK  ]
18  3.1.10              [  OK  ]
19  3.2.38              [  OK  ]
20  3.3.8               [  OK  ]
21  3.4.32              [  OK  ]
22  3.5.7               [  OK  ]
23  3.6.11              [  OK  ]
24  3.7.9               [  OK  ]
25  3.8.0               [  OK  ]
26  3.9-rc1             [  OK  ]

real    39m35.615s
user    1068m47.428s
sys     155m55.657s

Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 backport/.blacklist.map                            |    1 +
 backport/Kconfig                                   |    1 +
 backport/Makefile.kernel                           |    1 +
 backport/defconfigs/media                          |  506 ++++++++++++++++++++
 copy-list                                          |   17 +
 dependencies                                       |   44 ++
 .../collateral-evolutions/media/0001-pr_fmt.patch  |  493 +++++++++++++++++++
 .../media/0002-dma_mmap_coherent-revert.patch      |   58 +++
 .../media/0003-technisat-usb2-led-rename.patch     |   83 ++++
 9 files changed, 1204 insertions(+)
 create mode 100644 backport/defconfigs/media
 create mode 100644 patches/collateral-evolutions/media/0001-pr_fmt.patch
 create mode 100644 patches/collateral-evolutions/media/0002-dma_mmap_coherent-revert.patch
 create mode 100644 patches/collateral-evolutions/media/0003-technisat-usb2-led-rename.patch

diff --git a/backport/.blacklist.map b/backport/.blacklist.map
index dd58203..c1bdcfc 100644
--- a/backport/.blacklist.map
+++ b/backport/.blacklist.map
@@ -8,3 +8,4 @@
 # new-driver	old-driver
 iwlwifi		iwlagn
 iwl4965		iwlagn
+videodev	v4l2-compat-ioctl32
diff --git a/backport/Kconfig b/backport/Kconfig
index 6088bfe..2c75cd8 100644
--- a/backport/Kconfig
+++ b/backport/Kconfig
@@ -40,3 +40,4 @@ source drivers/gpu/drm/Kconfig
 source net/nfc/Kconfig
 
 source drivers/regulator/Kconfig
+source drivers/media/Kconfig
diff --git a/backport/Makefile.kernel b/backport/Makefile.kernel
index 2741cc9..27b44da 100644
--- a/backport/Makefile.kernel
+++ b/backport/Makefile.kernel
@@ -32,3 +32,4 @@ obj-$(CPTCFG_DRM) += drivers/gpu/drm/
 obj-$(CPTCFG_NFC) += net/nfc/
 obj-$(CPTCFG_NFC) += drivers/nfc/
 obj-$(CPTCFG_REGULATOR) += drivers/regulator/
+obj-$(CPTCFG_MEDIA_SUPPORT) += drivers/media/
diff --git a/backport/defconfigs/media b/backport/defconfigs/media
new file mode 100644
index 0000000..cbaf99f
--- /dev/null
+++ b/backport/defconfigs/media
@@ -0,0 +1,506 @@
+CPTCFG_DVB_A8293=y
+CPTCFG_DVB_AF9013=y
+CPTCFG_DVB_AF9033=y
+CPTCFG_DVB_ATBM8830=y
+CPTCFG_DVB_AU8522=y
+CPTCFG_DVB_AU8522_DTV=y
+CPTCFG_DVB_AU8522_V4L=y
+CPTCFG_DVB_AV7110=y
+CPTCFG_DVB_B2C2_FLEXCOP=y
+CPTCFG_DVB_B2C2_FLEXCOP_PCI=y
+CPTCFG_DVB_B2C2_FLEXCOP_USB=y
+CPTCFG_DVB_BCM3510=y
+CPTCFG_DVB_BT8XX=y
+CPTCFG_DVB_BUDGET=y
+CPTCFG_DVB_BUDGET_AV=y
+CPTCFG_DVB_BUDGET_CI=y
+CPTCFG_DVB_BUDGET_CORE=y
+CPTCFG_DVB_BUDGET_PATCH=y
+CPTCFG_DVB_CORE=y
+CPTCFG_DVB_CX22700=y
+CPTCFG_DVB_CX22702=y
+CPTCFG_DVB_CX24110=y
+CPTCFG_DVB_CX24116=y
+CPTCFG_DVB_CX24123=y
+CPTCFG_DVB_CXD2820R=y
+CPTCFG_DVB_DDBRIDGE=y
+CPTCFG_DVB_DIB3000MB=y
+CPTCFG_DVB_DIB3000MC=y
+CPTCFG_DVB_DIB7000M=y
+CPTCFG_DVB_DIB7000P=y
+CPTCFG_DVB_DIB8000=y
+CPTCFG_DVB_DIB9000=y
+CPTCFG_DVB_DM1105=y
+CPTCFG_DVB_DRXD=y
+CPTCFG_DVB_DRXK=y
+CPTCFG_DVB_DS3000=y
+CPTCFG_DVB_DUMMY_FE=y
+CPTCFG_DVB_EC100=y
+CPTCFG_DVB_FIREDTV=y
+CPTCFG_DVB_FIREDTV_INPUT=y
+CPTCFG_DVB_HD29L2=y
+CPTCFG_DVB_HOPPER=y
+CPTCFG_DVB_ISL6405=y
+CPTCFG_DVB_ISL6421=y
+CPTCFG_DVB_ISL6423=y
+CPTCFG_DVB_IT913X_FE=y
+CPTCFG_DVB_IX2505V=y
+CPTCFG_DVB_L64781=y
+CPTCFG_DVB_LG2160=y
+CPTCFG_DVB_LGDT3305=y
+CPTCFG_DVB_LGDT330X=y
+CPTCFG_DVB_LGS8GL5=y
+CPTCFG_DVB_LGS8GXX=y
+CPTCFG_DVB_LNBP21=y
+CPTCFG_DVB_LNBP22=y
+CPTCFG_DVB_M88RS2000=y
+CPTCFG_DVB_MANTIS=y
+CPTCFG_DVB_MB86A16=y
+CPTCFG_DVB_MB86A20S=y
+CPTCFG_DVB_MT312=y
+CPTCFG_DVB_MT352=y
+CPTCFG_DVB_NGENE=y
+CPTCFG_DVB_NXT200X=y
+CPTCFG_DVB_NXT6000=y
+CPTCFG_DVB_OR51132=y
+CPTCFG_DVB_OR51211=y
+CPTCFG_DVB_PLL=y
+CPTCFG_DVB_PLUTO2=y
+CPTCFG_DVB_PT1=y
+CPTCFG_DVB_RTL2830=y
+CPTCFG_DVB_RTL2832=y
+CPTCFG_DVB_S5H1409=y
+CPTCFG_DVB_S5H1411=y
+CPTCFG_DVB_S5H1420=y
+CPTCFG_DVB_S5H1432=y
+CPTCFG_DVB_S921=y
+CPTCFG_DVB_SI21XX=y
+CPTCFG_DVB_SP8870=y
+CPTCFG_DVB_SP887X=y
+CPTCFG_DVB_STB0899=y
+CPTCFG_DVB_STB6000=y
+CPTCFG_DVB_STB6100=y
+CPTCFG_DVB_STV0288=y
+CPTCFG_DVB_STV0297=y
+CPTCFG_DVB_STV0299=y
+CPTCFG_DVB_STV0367=y
+CPTCFG_DVB_STV0900=y
+CPTCFG_DVB_STV090x=y
+CPTCFG_DVB_STV6110=y
+CPTCFG_DVB_STV6110x=y
+CPTCFG_DVB_TDA10021=y
+CPTCFG_DVB_TDA10023=y
+CPTCFG_DVB_TDA10048=y
+CPTCFG_DVB_TDA1004X=y
+CPTCFG_DVB_TDA10071=y
+CPTCFG_DVB_TDA10086=y
+CPTCFG_DVB_TDA18271C2DD=y
+CPTCFG_DVB_TDA665x=y
+CPTCFG_DVB_TDA8083=y
+CPTCFG_DVB_TDA8261=y
+CPTCFG_DVB_TDA826X=y
+CPTCFG_DVB_TS2020=y
+CPTCFG_DVB_TTUSB_BUDGET=y
+CPTCFG_DVB_TTUSB_DEC=y
+CPTCFG_DVB_TUA6100=y
+CPTCFG_DVB_TUNER_CX24113=y
+CPTCFG_DVB_TUNER_DIB0070=y
+CPTCFG_DVB_TUNER_DIB0090=y
+CPTCFG_DVB_TUNER_ITD1000=y
+CPTCFG_DVB_USB=y
+CPTCFG_DVB_USB_A800=y
+CPTCFG_DVB_USB_AF9005=y
+CPTCFG_DVB_USB_AF9005_REMOTE=y
+CPTCFG_DVB_USB_AF9015=y
+CPTCFG_DVB_USB_AF9035=y
+CPTCFG_DVB_USB_ANYSEE=y
+CPTCFG_DVB_USB_AU6610=y
+CPTCFG_DVB_USB_AZ6007=y
+CPTCFG_DVB_USB_AZ6027=y
+CPTCFG_DVB_USB_CE6230=y
+CPTCFG_DVB_USB_CINERGY_T2=y
+CPTCFG_DVB_USB_CXUSB=y
+CPTCFG_DVB_USB_CYPRESS_FIRMWARE=y
+CPTCFG_DVB_USB_DIB0700=y
+CPTCFG_DVB_USB_DIBUSB_MB=y
+CPTCFG_DVB_USB_DIBUSB_MC=y
+CPTCFG_DVB_USB_DIGITV=y
+CPTCFG_DVB_USB_DTT200U=y
+CPTCFG_DVB_USB_DTV5100=y
+CPTCFG_DVB_USB_DW2102=y
+CPTCFG_DVB_USB_EC168=y
+CPTCFG_DVB_USB_FRIIO=y
+CPTCFG_DVB_USB_GL861=y
+CPTCFG_DVB_USB_GP8PSK=y
+CPTCFG_DVB_USB_IT913X=y
+CPTCFG_DVB_USB_LME2510=y
+CPTCFG_DVB_USB_M920X=y
+CPTCFG_DVB_USB_MXL111SF=y
+CPTCFG_DVB_USB_NOVA_T_USB2=y
+CPTCFG_DVB_USB_OPERA1=y
+CPTCFG_DVB_USB_PCTV452E=y
+CPTCFG_DVB_USB_RTL28XXU=y
+CPTCFG_DVB_USB_TECHNISAT_USB2=y
+CPTCFG_DVB_USB_TTUSB2=y
+CPTCFG_DVB_USB_UMT_010=y
+CPTCFG_DVB_USB_V2=y
+CPTCFG_DVB_USB_VP702X=y
+CPTCFG_DVB_USB_VP7045=y
+CPTCFG_DVB_VES1820=y
+CPTCFG_DVB_VES1X93=y
+CPTCFG_DVB_ZL10036=y
+CPTCFG_DVB_ZL10039=y
+CPTCFG_DVB_ZL10353=y
+CPTCFG_I2C_SI470X=y
+CPTCFG_I2C_SI4713=y
+CPTCFG_IR_ENE=y
+CPTCFG_IR_FINTEK=y
+CPTCFG_IR_GPIO_CIR=y
+CPTCFG_IR_IGUANA=y
+CPTCFG_IR_IMON=y
+CPTCFG_IR_ITE_CIR=y
+CPTCFG_IR_JVC_DECODER=y
+CPTCFG_IR_LIRC_CODEC=y
+CPTCFG_IR_MCE_KBD_DECODER=y
+CPTCFG_IR_MCEUSB=y
+CPTCFG_IR_NEC_DECODER=y
+CPTCFG_IR_NUVOTON=y
+CPTCFG_IR_RC5_DECODER=y
+CPTCFG_IR_RC5_SZ_DECODER=y
+CPTCFG_IR_RC6_DECODER=y
+CPTCFG_IR_REDRAT3=y
+CPTCFG_IR_RX51=y
+CPTCFG_IR_SANYO_DECODER=y
+CPTCFG_IR_SONY_DECODER=y
+CPTCFG_IR_STREAMZAP=y
+CPTCFG_IR_TTUSBIR=y
+CPTCFG_IR_WINBOND_CIR=y
+CPTCFG_LIRC=y
+CPTCFG_MANTIS_CORE=y
+CPTCFG_MEDIA_ALTERA_CI=y
+CPTCFG_MEDIA_SUPPORT=y
+CPTCFG_MEDIA_TUNER_E4000=y
+CPTCFG_MEDIA_TUNER_FC0011=y
+CPTCFG_MEDIA_TUNER_FC0012=y
+CPTCFG_MEDIA_TUNER_FC0013=y
+CPTCFG_MEDIA_TUNER_FC2580=y
+CPTCFG_MEDIA_TUNER_IT913X=y
+CPTCFG_MEDIA_TUNER_MAX2165=y
+CPTCFG_MEDIA_TUNER_MC44S803=y
+CPTCFG_MEDIA_TUNER_MT2060=y
+CPTCFG_MEDIA_TUNER_MT2063=y
+CPTCFG_MEDIA_TUNER_MT20XX=y
+CPTCFG_MEDIA_TUNER_MT2131=y
+CPTCFG_MEDIA_TUNER_MT2266=y
+CPTCFG_MEDIA_TUNER_MXL5005S=y
+CPTCFG_MEDIA_TUNER_MXL5007T=y
+CPTCFG_MEDIA_TUNER_QT1010=y
+CPTCFG_MEDIA_TUNER_SIMPLE=y
+CPTCFG_MEDIA_TUNER_TDA18212=y
+CPTCFG_MEDIA_TUNER_TDA18218=y
+CPTCFG_MEDIA_TUNER_TDA18271=y
+CPTCFG_MEDIA_TUNER_TDA827X=y
+CPTCFG_MEDIA_TUNER_TDA8290=y
+CPTCFG_MEDIA_TUNER_TDA9887=y
+CPTCFG_MEDIA_TUNER_TEA5761=y
+CPTCFG_MEDIA_TUNER_TEA5767=y
+CPTCFG_MEDIA_TUNER_TUA9001=y
+CPTCFG_MEDIA_TUNER_XC2028=y
+CPTCFG_MEDIA_TUNER_XC4000=y
+CPTCFG_MEDIA_TUNER_XC5000=y
+CPTCFG_RADIO_AZTECH=y
+CPTCFG_RADIO_CADET=y
+CPTCFG_RADIO_GEMTEK=y
+CPTCFG_RADIO_ISA=y
+CPTCFG_RADIO_MAXIRADIO=y
+CPTCFG_RADIO_MIROPCM20=y
+CPTCFG_RADIO_RTRACK=y
+CPTCFG_RADIO_RTRACK2=y
+CPTCFG_RADIO_SAA7706H=y
+CPTCFG_RADIO_SF16FMI=y
+CPTCFG_RADIO_SF16FMR2=y
+CPTCFG_RADIO_SHARK=y
+CPTCFG_RADIO_SHARK2=y
+CPTCFG_RADIO_SI470X=y
+CPTCFG_RADIO_SI4713=y
+CPTCFG_RADIO_TEA5764=y
+CPTCFG_RADIO_TEF6862=y
+CPTCFG_RADIO_TERRATEC=y
+CPTCFG_RADIO_TIMBERDALE=y
+CPTCFG_RADIO_TRUST=y
+CPTCFG_RADIO_TYPHOON=y
+CPTCFG_RADIO_WL1273=y
+CPTCFG_RADIO_WL128X=y
+CPTCFG_RADIO_ZOLTRIX=y
+CPTCFG_RC_ATI_REMOTE=y
+CPTCFG_RC_CORE=y
+CPTCFG_RC_LOOPBACK=y
+CPTCFG_RC_MAP=y
+CPTCFG_SMS_SDIO_DRV=y
+CPTCFG_SMS_SIANO_MDTV=y
+CPTCFG_SMS_USB_DRV=y
+CPTCFG_SOC_CAMERA=y
+CPTCFG_SOC_CAMERA_IMX074=y
+CPTCFG_SOC_CAMERA_MT9M001=y
+CPTCFG_SOC_CAMERA_MT9M111=y
+CPTCFG_SOC_CAMERA_MT9T031=y
+CPTCFG_SOC_CAMERA_MT9T112=y
+CPTCFG_SOC_CAMERA_MT9V022=y
+CPTCFG_SOC_CAMERA_OV2640=y
+CPTCFG_SOC_CAMERA_OV5642=y
+CPTCFG_SOC_CAMERA_OV6650=y
+CPTCFG_SOC_CAMERA_OV772X=y
+CPTCFG_SOC_CAMERA_OV9640=y
+CPTCFG_SOC_CAMERA_OV9740=y
+CPTCFG_SOC_CAMERA_PLATFORM=y
+CPTCFG_SOC_CAMERA_RJ54N1=y
+CPTCFG_SOC_CAMERA_TW9910=y
+CPTCFG_STA2X11_VIP=y
+CPTCFG_TTPCI_EEPROM=y
+CPTCFG_USB_DSBR=y
+CPTCFG_USB_GL860=y
+CPTCFG_USB_GSPCA=y
+CPTCFG_USB_GSPCA_BENQ=y
+CPTCFG_USB_GSPCA_CONEX=y
+CPTCFG_USB_GSPCA_CPIA1=y
+CPTCFG_USB_GSPCA_ETOMS=y
+CPTCFG_USB_GSPCA_FINEPIX=y
+CPTCFG_USB_GSPCA_JEILINJ=y
+CPTCFG_USB_GSPCA_JL2005BCD=y
+CPTCFG_USB_GSPCA_KINECT=y
+CPTCFG_USB_GSPCA_KONICA=y
+CPTCFG_USB_GSPCA_MARS=y
+CPTCFG_USB_GSPCA_MR97310A=y
+CPTCFG_USB_GSPCA_NW80X=y
+CPTCFG_USB_GSPCA_OV519=y
+CPTCFG_USB_GSPCA_OV534=y
+CPTCFG_USB_GSPCA_OV534_9=y
+CPTCFG_USB_GSPCA_PAC207=y
+CPTCFG_USB_GSPCA_PAC7302=y
+CPTCFG_USB_GSPCA_PAC7311=y
+CPTCFG_USB_GSPCA_SE401=y
+CPTCFG_USB_GSPCA_SN9C2028=y
+CPTCFG_USB_GSPCA_SN9C20X=y
+CPTCFG_USB_GSPCA_SONIXB=y
+CPTCFG_USB_GSPCA_SONIXJ=y
+CPTCFG_USB_GSPCA_SPCA1528=y
+CPTCFG_USB_GSPCA_SPCA500=y
+CPTCFG_USB_GSPCA_SPCA501=y
+CPTCFG_USB_GSPCA_SPCA505=y
+CPTCFG_USB_GSPCA_SPCA506=y
+CPTCFG_USB_GSPCA_SPCA508=y
+CPTCFG_USB_GSPCA_SPCA561=y
+CPTCFG_USB_GSPCA_SQ905=y
+CPTCFG_USB_GSPCA_SQ905C=y
+CPTCFG_USB_GSPCA_SQ930X=y
+CPTCFG_USB_GSPCA_STK014=y
+CPTCFG_USB_GSPCA_STV0680=y
+CPTCFG_USB_GSPCA_SUNPLUS=y
+CPTCFG_USB_GSPCA_T613=y
+CPTCFG_USB_GSPCA_TOPRO=y
+CPTCFG_USB_GSPCA_TV8532=y
+CPTCFG_USB_GSPCA_VC032X=y
+CPTCFG_USB_GSPCA_VICAM=y
+CPTCFG_USB_GSPCA_XIRLINK_CIT=y
+CPTCFG_USB_GSPCA_ZC3XX=y
+CPTCFG_USB_KEENE=y
+CPTCFG_USB_M5602=y
+CPTCFG_USB_MA901=y
+CPTCFG_USB_MR800=y
+CPTCFG_USB_PWC=y
+CPTCFG_USB_S2255=y
+CPTCFG_USB_SI470X=y
+CPTCFG_USB_SN9C102=y
+CPTCFG_USB_STKWEBCAM=y
+CPTCFG_USB_STV06XX=y
+CPTCFG_USB_VIDEO_CLASS=y
+CPTCFG_USB_ZR364XX=y
+CPTCFG_V4L2_MEM2MEM_DEV=y
+CPTCFG_VIDEO_AD9389B=y
+CPTCFG_VIDEO_ADP1653=y
+CPTCFG_VIDEO_ADV7170=y
+CPTCFG_VIDEO_ADV7175=y
+CPTCFG_VIDEO_ADV7180=y
+CPTCFG_VIDEO_ADV7183=y
+CPTCFG_VIDEO_ADV7343=y
+CPTCFG_VIDEO_ADV7393=y
+CPTCFG_VIDEO_ADV7604=y
+CPTCFG_VIDEO_AK881X=y
+CPTCFG_VIDEO_APTINA_PLL=y
+CPTCFG_VIDEO_AS3645A=y
+CPTCFG_VIDEO_ATMEL_ISI=y
+CPTCFG_VIDEO_AU0828=y
+CPTCFG_VIDEO_BLACKFIN_CAPTURE=y
+CPTCFG_VIDEO_BLACKFIN_PPI=y
+CPTCFG_VIDEO_BT819=y
+CPTCFG_VIDEO_BT848=y
+CPTCFG_VIDEO_BT856=y
+CPTCFG_VIDEO_BT866=y
+CPTCFG_VIDEO_BTCX=y
+CPTCFG_VIDEOBUF2_CORE=y
+CPTCFG_VIDEOBUF2_DMA_CONTIG=y
+CPTCFG_VIDEOBUF2_DMA_SG=y
+CPTCFG_VIDEOBUF2_MEMOPS=y
+CPTCFG_VIDEOBUF2_VMALLOC=y
+CPTCFG_VIDEOBUF_DMA_CONTIG=y
+CPTCFG_VIDEOBUF_DMA_SG=y
+CPTCFG_VIDEOBUF_DVB=y
+CPTCFG_VIDEOBUF_GEN=y
+CPTCFG_VIDEOBUF_VMALLOC=y
+CPTCFG_VIDEO_BWQCAM=y
+CPTCFG_VIDEO_CAFE_CCIC=y
+CPTCFG_VIDEO_CODA=y
+CPTCFG_VIDEO_CPIA2=y
+CPTCFG_VIDEO_CQCAM=y
+CPTCFG_VIDEO_CS5345=y
+CPTCFG_VIDEO_CS53L32A=y
+CPTCFG_VIDEO_CX18=y
+CPTCFG_VIDEO_CX18_ALSA=y
+CPTCFG_VIDEO_CX231XX=y
+CPTCFG_VIDEO_CX231XX_ALSA=y
+CPTCFG_VIDEO_CX231XX_DVB=y
+CPTCFG_VIDEO_CX231XX_RC=y
+CPTCFG_VIDEO_CX2341X=y
+CPTCFG_VIDEO_CX23885=y
+CPTCFG_VIDEO_CX25821=y
+CPTCFG_VIDEO_CX25821_ALSA=y
+CPTCFG_VIDEO_CX25840=y
+CPTCFG_VIDEO_CX88=y
+CPTCFG_VIDEO_CX88_ALSA=y
+CPTCFG_VIDEO_CX88_BLACKBIRD=y
+CPTCFG_VIDEO_CX88_DVB=y
+CPTCFG_VIDEO_CX88_MPEG=y
+CPTCFG_VIDEO_CX88_VP3054=y
+CPTCFG_VIDEO_DAVINCI_VPBE_DISPLAY=y
+CPTCFG_VIDEO_DAVINCI_VPIF=y
+CPTCFG_VIDEO_DAVINCI_VPIF_CAPTURE=y
+CPTCFG_VIDEO_DAVINCI_VPIF_DISPLAY=y
+CPTCFG_VIDEO_DEV=y
+CPTCFG_VIDEO_DM355_CCDC=y
+CPTCFG_VIDEO_DM6446_CCDC=y
+CPTCFG_VIDEO_EM28XX=y
+CPTCFG_VIDEO_EM28XX_ALSA=y
+CPTCFG_VIDEO_EM28XX_DVB=y
+CPTCFG_VIDEO_EM28XX_RC=y
+CPTCFG_VIDEO_EXYNOS_FIMC_LITE=y
+CPTCFG_VIDEO_FB_IVTV=y
+CPTCFG_VIDEO_HDPVR=y
+CPTCFG_VIDEO_HEXIUM_GEMINI=y
+CPTCFG_VIDEO_HEXIUM_ORION=y
+CPTCFG_VIDEO_IR_I2C=y
+CPTCFG_VIDEO_ISIF=y
+CPTCFG_VIDEO_IVTV=y
+CPTCFG_VIDEO_IVTV_ALSA=y
+CPTCFG_VIDEO_KS0127=y
+CPTCFG_VIDEO_M32R_AR_M64278=y
+CPTCFG_VIDEO_M52790=y
+CPTCFG_VIDEO_M5MOLS=y
+CPTCFG_VIDEO_MEM2MEM_DEINTERLACE=y
+CPTCFG_VIDEO_MEM2MEM_TESTDEV=y
+CPTCFG_VIDEO_MEYE=y
+CPTCFG_VIDEO_MMP_CAMERA=y
+CPTCFG_VIDEO_MSP3400=y
+CPTCFG_VIDEO_MT9M032=y
+CPTCFG_VIDEO_MT9P031=y
+CPTCFG_VIDEO_MT9T001=y
+CPTCFG_VIDEO_MT9V011=y
+CPTCFG_VIDEO_MT9V032=y
+CPTCFG_VIDEO_MX1=y
+CPTCFG_VIDEO_MX2=y
+CPTCFG_VIDEO_MX2_EMMAPRP=y
+CPTCFG_VIDEO_MX3=y
+CPTCFG_VIDEO_MXB=y
+CPTCFG_VIDEO_NOON010PC30=y
+CPTCFG_VIDEO_OMAP1=y
+CPTCFG_VIDEO_OMAP2=y
+CPTCFG_VIDEO_OMAP2_VOUT=y
+CPTCFG_VIDEO_OMAP3=y
+CPTCFG_VIDEO_OMAP3_DEBUG=y
+CPTCFG_VIDEO_OV7640=y
+CPTCFG_VIDEO_OV7670=y
+CPTCFG_VIDEO_OV9650=y
+CPTCFG_VIDEO_PMS=y
+CPTCFG_VIDEO_PVRUSB2=y
+CPTCFG_VIDEO_PXA27x=y
+CPTCFG_VIDEO_S3C_CAMIF=y
+CPTCFG_VIDEO_S5C73M3=y
+CPTCFG_VIDEO_S5K4ECGX=y
+CPTCFG_VIDEO_S5K6AA=y
+CPTCFG_VIDEO_S5P_FIMC=y
+CPTCFG_VIDEO_S5P_MIPI_CSIS=y
+CPTCFG_VIDEO_SAA6588=y
+CPTCFG_VIDEO_SAA7110=y
+CPTCFG_VIDEO_SAA711X=y
+CPTCFG_VIDEO_SAA7127=y
+CPTCFG_VIDEO_SAA7134=y
+CPTCFG_VIDEO_SAA7134_ALSA=y
+CPTCFG_VIDEO_SAA7134_DVB=y
+CPTCFG_VIDEO_SAA7134_RC=y
+CPTCFG_VIDEO_SAA7146=y
+CPTCFG_VIDEO_SAA7146_VV=y
+CPTCFG_VIDEO_SAA7164=y
+CPTCFG_VIDEO_SAA717X=y
+CPTCFG_VIDEO_SAA7185=y
+CPTCFG_VIDEO_SAA7191=y
+CPTCFG_VIDEO_SAMSUNG_EXYNOS_GSC=y
+CPTCFG_VIDEO_SAMSUNG_S5P_FIMC=y
+CPTCFG_VIDEO_SAMSUNG_S5P_G2D=y
+CPTCFG_VIDEO_SAMSUNG_S5P_HDMI=y
+CPTCFG_VIDEO_SAMSUNG_S5P_HDMIPHY=y
+CPTCFG_VIDEO_SAMSUNG_S5P_JPEG=y
+CPTCFG_VIDEO_SAMSUNG_S5P_MFC=y
+CPTCFG_VIDEO_SAMSUNG_S5P_MIXER=y
+CPTCFG_VIDEO_SAMSUNG_S5P_SDO=y
+CPTCFG_VIDEO_SAMSUNG_S5P_SII9234=y
+CPTCFG_VIDEO_SAMSUNG_S5P_TV=y
+CPTCFG_VIDEO_SH_MOBILE_CEU=y
+CPTCFG_VIDEO_SH_MOBILE_CSI2=y
+CPTCFG_VIDEO_SH_VEU=y
+CPTCFG_VIDEO_SH_VOU=y
+CPTCFG_VIDEO_SMIAPP=y
+CPTCFG_VIDEO_SMIAPP_PLL=y
+CPTCFG_VIDEO_SONY_BTF_MPX=y
+CPTCFG_VIDEO_SR030PC30=y
+CPTCFG_VIDEO_STK1160=y
+CPTCFG_VIDEO_TCM825X=y
+CPTCFG_VIDEO_TDA7432=y
+CPTCFG_VIDEO_TDA9840=y
+CPTCFG_VIDEO_TEA6415C=y
+CPTCFG_VIDEO_TEA6420=y
+CPTCFG_VIDEO_THS7303=y
+CPTCFG_VIDEO_TIMBERDALE=y
+CPTCFG_VIDEO_TLG2300=y
+CPTCFG_VIDEO_TLV320AIC23B=y
+CPTCFG_VIDEO_TM6000=y
+CPTCFG_VIDEO_TM6000_ALSA=y
+CPTCFG_VIDEO_TM6000_DVB=y
+CPTCFG_VIDEO_TUNER=y
+CPTCFG_VIDEO_TVAUDIO=y
+CPTCFG_VIDEO_TVEEPROM=y
+CPTCFG_VIDEO_TVP514X=y
+CPTCFG_VIDEO_TVP5150=y
+CPTCFG_VIDEO_TVP7002=y
+CPTCFG_VIDEO_TW2804=y
+CPTCFG_VIDEO_TW9903=y
+CPTCFG_VIDEO_TW9906=y
+CPTCFG_VIDEO_UDA1342=y
+CPTCFG_VIDEO_UPD64031A=y
+CPTCFG_VIDEO_UPD64083=y
+CPTCFG_VIDEO_USBVISION=y
+CPTCFG_VIDEO_V4L2=y
+CPTCFG_VIDEO_V4L2_INT_DEVICE=y
+CPTCFG_VIDEO_VIA_CAMERA=y
+CPTCFG_VIDEO_VINO=y
+CPTCFG_VIDEO_VIU=y
+CPTCFG_VIDEO_VIVI=y
+CPTCFG_VIDEO_VP27SMPX=y
+CPTCFG_VIDEO_VPFE_CAPTURE=y
+CPTCFG_VIDEO_VPSS_SYSTEM=y
+CPTCFG_VIDEO_VPX3220=y
+CPTCFG_VIDEO_VS6624=y
+CPTCFG_VIDEO_W9966=y
+CPTCFG_VIDEO_WM8739=y
+CPTCFG_VIDEO_WM8775=y
+CPTCFG_VIDEO_ZORAN=y
+CPTCFG_VIDEO_ZORAN_DC30=y
+CPTCFG_VIDEO_ZORAN_ZR36060=y
diff --git a/copy-list b/copy-list
index 9771c43..0c25be5 100644
--- a/copy-list
+++ b/copy-list
@@ -168,3 +168,20 @@ include/linux/regulator/userspace-consumer.h
 include/linux/platform_data/lp8755.h
 
 drivers/regulator/
+
+# Media
+include/media/
+
+include/linux/videodev2.h
+include/linux/video_output.h
+
+include/uapi/linux/media.h
+include/uapi/linux/dvb/
+include/uapi/linux/v4l2-common.h
+include/uapi/linux/v4l2-controls.h
+include/uapi/linux/v4l2-dv-timings.h
+include/uapi/linux/v4l2-mediabus.h
+include/uapi/linux/v4l2-subdev.h
+include/uapi/linux/videodev2.h
+
+drivers/media/
diff --git a/dependencies b/dependencies
index 0ab99d4..0658289 100644
--- a/dependencies
+++ b/dependencies
@@ -68,6 +68,50 @@ REGULATOR_PALMAS DISABLE
 REGULATOR_DA9055 DISABLE
 REGULATOR_S5M8767 DISABLE
 
+# Media
+MEDIA_SUPPORT 3.2
+# Some media drivers however depend on module deferral mechanism
+# Lets not enable those unless that's available.
+VIDEO_S3C_CAMIF 3.4
+VIDEO_SAMSUNG_S5P_FIMC 3.4
+IR_GPIO_CIR 3.4
+# Some media drivers depend on the CONFIG_REGULATOR which
+# we only support on >= 3.4 give that reguatory itself depends
+# on -EPROBE_DEFER.
+SOC_CAMERA 3.4
+SOC_CAMERA_IMX074 3.4
+SOC_CAMERA_MT9M001 3.4
+SOC_CAMERA_MT9M111 3.4
+SOC_CAMERA_MT9T031 3.4
+SOC_CAMERA_MT9T112 3.4
+SOC_CAMERA_MT9V022 3.4
+SOC_CAMERA_OV2640 3.4
+SOC_CAMERA_OV5642 3.4
+SOC_CAMERA_OV6650 3.4
+SOC_CAMERA_OV772X 3.4
+SOC_CAMERA_OV9640 3.4
+SOC_CAMERA_OV9740 3.4
+SOC_CAMERA_RJ54N1 3.4
+SOC_CAMERA_TW9910 3.4
+# There are some odd comile errors here I don't want
+# to bother with right now
+VIDEO_MEM2MEM_DEINTERLACE DISABLE
+# 49920bc6 and 1003cab8 and while it seems there is a
+# one to one map DMA_FROM_DEVICE to DMA_DEV_TO_MEM
+# I can't verify this fully yet.
+VIDEO_TIMBERDALE 3.4
+# Can't figure this out yet either
+DVB_DDBRIDGE DISABLE
+# I give up on these guys for now
+RADIO_MAXIRADIO DISABLE
+RADIO_SHARK DISABLE
+VIDEO_IVTV DISABLE
+VIDEO_MEYE DISABLE
+DVB_NGENE DISABLE
+DVB_USB_PCTV452E DISABLE
+USB_GSPCA DISABLE
+VIDEO_MXB DISABLE
+
 # This requires proc_create(), and that doesn't exist before 2.6.24
 LIBIPW_DEBUG 2.6.25
 
diff --git a/patches/collateral-evolutions/media/0001-pr_fmt.patch b/patches/collateral-evolutions/media/0001-pr_fmt.patch
new file mode 100644
index 0000000..17aa93a
--- /dev/null
+++ b/patches/collateral-evolutions/media/0001-pr_fmt.patch
@@ -0,0 +1,493 @@
+We can't really get this udef'd in any easier way. If you figure it out..
+great.
+
+--- a/drivers/media/media-devnode.c
++++ b/drivers/media/media-devnode.c
+@@ -29,11 +29,12 @@
+  * character devices using a dynamic major number and proper reference
+  * counting.
+  */
+-
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <linux/errno.h>
+ #include <linux/init.h>
++#include <linux/printk.h>
+ #include <linux/module.h>
+ #include <linux/kernel.h>
+ #include <linux/kmod.h>
+--- a/drivers/media/common/saa7146/saa7146_i2c.c
++++ b/drivers/media/common/saa7146/saa7146_i2c.c
+@@ -1,5 +1,7 @@
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <media/saa7146_vv.h>
+ 
+ static u32 saa7146_i2c_func(struct i2c_adapter *adapter)
+--- a/drivers/media/common/saa7146/saa7146_fops.c
++++ b/drivers/media/common/saa7146/saa7146_fops.c
+@@ -1,5 +1,7 @@
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <media/saa7146_vv.h>
+ #include <linux/module.h>
+ 
+--- a/drivers/media/common/saa7146/saa7146_core.c
++++ b/drivers/media/common/saa7146/saa7146_core.c
+@@ -17,9 +17,10 @@
+     along with this program; if not, write to the Free Software
+     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+-
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <media/saa7146.h>
+ #include <linux/module.h>
+ 
+--- a/drivers/media/common/saa7146/saa7146_video.c
++++ b/drivers/media/common/saa7146/saa7146_video.c
+@@ -1,9 +1,11 @@
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <media/saa7146_vv.h>
+ #include <media/v4l2-chip-ident.h>
+ #include <media/v4l2-event.h>
+ #include <media/v4l2-ctrls.h>
++#include <linux/printk.h>
+ #include <linux/module.h>
+ 
+ static int max_memory = 32;
+--- a/drivers/media/common/saa7146/saa7146_hlp.c
++++ b/drivers/media/common/saa7146/saa7146_hlp.c
+@@ -1,5 +1,7 @@
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/kernel.h>
+ #include <linux/export.h>
+ #include <media/saa7146_vv.h>
+--- a/drivers/media/pci/bt8xx/bttv-driver.c
++++ b/drivers/media/pci/bt8xx/bttv-driver.c
+@@ -34,8 +34,10 @@
+     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/init.h>
+ #include <linux/module.h>
+ #include <linux/delay.h>
+--- a/drivers/media/pci/bt8xx/bttv-cards.c
++++ b/drivers/media/pci/bt8xx/bttv-cards.c
+@@ -24,9 +24,10 @@
+     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ 
+ */
+-
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/delay.h>
+ #include <linux/module.h>
+ #include <linux/kmod.h>
+--- a/drivers/media/dvb-frontends/nxt200x.c
++++ b/drivers/media/dvb-frontends/nxt200x.c
+@@ -37,12 +37,14 @@
+  * /usr/lib/hotplug/firmware/ or /lib/firmware/
+  * (depending on configuration of firmware hotplug).
+  */
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #define NXT2002_DEFAULT_FIRMWARE "dvb-fe-nxt2002.fw"
+ #define NXT2004_DEFAULT_FIRMWARE "dvb-fe-nxt2004.fw"
+ #define CRC_CCIT_MASK 0x1021
+ 
++#include <linux/printk.h>
+ #include <linux/kernel.h>
+ #include <linux/init.h>
+ #include <linux/module.h>
+--- a/drivers/media/dvb-frontends/or51211.c
++++ b/drivers/media/dvb-frontends/or51211.c
+@@ -21,7 +21,7 @@
+  *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+  *
+ */
+-
++#undef pr_fmt
+ #define pr_fmt(fmt)	KBUILD_MODNAME ": %s: " fmt, __func__
+ 
+ /*
+@@ -32,6 +32,7 @@
+  */
+ #define OR51211_DEFAULT_FIRMWARE "dvb-fe-or51211.fw"
+ 
++#include <linux/printk.h>
+ #include <linux/kernel.h>
+ #include <linux/module.h>
+ #include <linux/device.h>
+--- a/drivers/media/pci/bt8xx/bttv-risc.c
++++ b/drivers/media/pci/bt8xx/bttv-risc.c
+@@ -23,9 +23,10 @@
+     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ 
+ */
+-
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/module.h>
+ #include <linux/init.h>
+ #include <linux/slab.h>
+--- a/drivers/media/pci/bt8xx/bttv-vbi.c
++++ b/drivers/media/pci/bt8xx/bttv-vbi.c
+@@ -22,9 +22,10 @@
+     along with this program; if not, write to the Free Software
+     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+-
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/module.h>
+ #include <linux/errno.h>
+ #include <linux/fs.h>
+--- a/drivers/media/pci/bt8xx/bttv-i2c.c
++++ b/drivers/media/pci/bt8xx/bttv-i2c.c
+@@ -26,9 +26,10 @@
+     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ 
+ */
+-
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/module.h>
+ #include <linux/init.h>
+ #include <linux/delay.h>
+--- a/drivers/media/pci/bt8xx/bttv-gpio.c
++++ b/drivers/media/pci/bt8xx/bttv-gpio.c
+@@ -25,9 +25,10 @@
+     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ 
+ */
+-
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/module.h>
+ #include <linux/init.h>
+ #include <linux/delay.h>
+--- a/drivers/media/pci/bt8xx/bttv-input.c
++++ b/drivers/media/pci/bt8xx/bttv-input.c
+@@ -17,9 +17,10 @@
+  * along with this program; if not, write to the Free Software
+  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+  */
+-
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/module.h>
+ #include <linux/init.h>
+ #include <linux/delay.h>
+--- a/drivers/media/pci/bt8xx/dvb-bt8xx.c
++++ b/drivers/media/pci/bt8xx/dvb-bt8xx.c
+@@ -19,8 +19,10 @@
+  *
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) "dvb_bt8xx: " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/bitops.h>
+ #include <linux/module.h>
+ #include <linux/init.h>
+--- a/drivers/media/common/siano/smsdvb-debugfs.c
++++ b/drivers/media/common/siano/smsdvb-debugfs.c
+@@ -17,8 +17,10 @@
+  *
+  ***********************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/module.h>
+ #include <linux/slab.h>
+ #include <linux/init.h>
+--- a/drivers/media/pci/cx25821/cx25821-alsa.c
++++ b/drivers/media/pci/cx25821/cx25821-alsa.c
+@@ -20,8 +20,10 @@
+  *
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/module.h>
+ #include <linux/init.h>
+ #include <linux/device.h>
+--- a/drivers/media/pci/cx25821/cx25821-audio-upstream.c
++++ b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
+@@ -20,11 +20,13 @@
+  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include "cx25821-video.h"
+ #include "cx25821-audio-upstream.h"
+ 
++#include <linux/printk.h>
+ #include <linux/fs.h>
+ #include <linux/errno.h>
+ #include <linux/kernel.h>
+--- a/drivers/media/pci/cx25821/cx25821-cards.c
++++ b/drivers/media/pci/cx25821/cx25821-cards.c
+@@ -21,8 +21,10 @@
+  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/init.h>
+ #include <linux/module.h>
+ #include <linux/pci.h>
+--- a/drivers/media/pci/cx25821/cx25821-core.c
++++ b/drivers/media/pci/cx25821/cx25821-core.c
+@@ -21,8 +21,10 @@
+  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/i2c.h>
+ #include <linux/slab.h>
+ #include "cx25821.h"
+--- a/drivers/media/pci/cx25821/cx25821-i2c.c
++++ b/drivers/media/pci/cx25821/cx25821-i2c.c
+@@ -21,9 +21,11 @@
+  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include "cx25821.h"
++#include <linux/printk.h>
+ #include <linux/i2c.h>
+ 
+ static unsigned int i2c_debug;
+--- a/drivers/media/pci/cx25821/cx25821-medusa-video.c
++++ b/drivers/media/pci/cx25821/cx25821-medusa-video.c
+@@ -20,12 +20,15 @@
+  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include "cx25821.h"
+ #include "cx25821-medusa-video.h"
+ #include "cx25821-biffuncs.h"
+ 
++#include <linux/printk.h>
++
+ /*
+  * medusa_enable_bluefield_output()
+  *
+--- a/drivers/media/pci/cx25821/cx25821-video.c
++++ b/drivers/media/pci/cx25821/cx25821-video.c
+@@ -24,9 +24,11 @@
+  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include "cx25821-video.h"
++#include <linux/printk.h>
+ 
+ MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
+ MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
+--- a/drivers/media/pci/cx25821/cx25821-video-upstream.c
++++ b/drivers/media/pci/cx25821/cx25821-video-upstream.c
+@@ -20,11 +20,13 @@
+  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include "cx25821-video.h"
+ #include "cx25821-video-upstream.h"
+ 
++#include <linux/printk.h>
+ #include <linux/fs.h>
+ #include <linux/errno.h>
+ #include <linux/kernel.h>
+--- a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
++++ b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
+@@ -20,11 +20,13 @@
+  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include "cx25821-video.h"
+ #include "cx25821-video-upstream-ch2.h"
+ 
++#include <linux/printk.h>
+ #include <linux/fs.h>
+ #include <linux/errno.h>
+ #include <linux/kernel.h>
+--- a/drivers/media/rc/imon.c
++++ b/drivers/media/rc/imon.c
+@@ -26,8 +26,10 @@
+  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
+ 
++#include <linux/printk.h>
+ #include <linux/errno.h>
+ #include <linux/init.h>
+ #include <linux/kernel.h>
+--- a/drivers/media/rc/fintek-cir.c
++++ b/drivers/media/rc/fintek-cir.c
+@@ -23,8 +23,10 @@
+  * USA
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/kernel.h>
+ #include <linux/module.h>
+ #include <linux/pnp.h>
+--- a/drivers/media/rc/nuvoton-cir.c
++++ b/drivers/media/rc/nuvoton-cir.c
+@@ -25,8 +25,10 @@
+  * USA
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/kernel.h>
+ #include <linux/module.h>
+ #include <linux/pnp.h>
+--- a/drivers/media/rc/ene_ir.c
++++ b/drivers/media/rc/ene_ir.c
+@@ -30,8 +30,10 @@
+  *
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/kernel.h>
+ #include <linux/module.h>
+ #include <linux/pnp.h>
+--- a/drivers/media/rc/winbond-cir.c
++++ b/drivers/media/rc/winbond-cir.c
+@@ -40,8 +40,10 @@
+  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/module.h>
+ #include <linux/pnp.h>
+ #include <linux/interrupt.h>
+--- a/drivers/media/pci/saa7146/hexium_orion.c
++++ b/drivers/media/pci/saa7146/hexium_orion.c
+@@ -21,11 +21,13 @@
+     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #define DEBUG_VARIABLE debug
+ 
+ #include <media/saa7146_vv.h>
++#include <linux/printk.h>
+ #include <linux/module.h>
+ 
+ static int debug;
+--- a/drivers/media/pci/saa7146/hexium_gemini.c
++++ b/drivers/media/pci/saa7146/hexium_gemini.c
+@@ -21,12 +21,14 @@
+     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #define DEBUG_VARIABLE debug
+ 
+ #include <media/saa7146_vv.h>
+ #include <linux/module.h>
++#include <linux/printk.h>
+ 
+ static int debug;
+ module_param(debug, int, 0);
+--- a/drivers/media/pci/ttpci/budget-av.c
++++ b/drivers/media/pci/ttpci/budget-av.c
+@@ -33,8 +33,10 @@
+  * the project's page is at http://www.linuxtv.org/ 
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include "budget.h"
+ #include "stv0299.h"
+ #include "stb0899_drv.h"
+--- a/drivers/media/pci/ttpci/av7110_v4l.c
++++ b/drivers/media/pci/ttpci/av7110_v4l.c
+@@ -25,8 +25,10 @@
+  * the project's page is at http://www.linuxtv.org/ 
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/kernel.h>
+ #include <linux/types.h>
+ #include <linux/delay.h>
diff --git a/patches/collateral-evolutions/media/0002-dma_mmap_coherent-revert.patch b/patches/collateral-evolutions/media/0002-dma_mmap_coherent-revert.patch
new file mode 100644
index 0000000..4d3a77e
--- /dev/null
+++ b/patches/collateral-evolutions/media/0002-dma_mmap_coherent-revert.patch
@@ -0,0 +1,58 @@
+Commit c60520fa needs to be reverted for older kernels because
+although we can backport some new DMA changes some other
+larger changes ended up extending some core dma data
+structures, for details see bca0fa5f as an example. We're
+aided with this revert by having added vb2_mmap_pfn_range() to
+compat. The main reason to revert is usage of the new
+dma_mmap_coherent() and core changes required via
+bca0fa5f.
+
+commit c60520fa50cd86d64bc8ebb34300ddc4ca91393d
+Author: Marek Szyprowski <m.szyprowski@samsung.com>
+Date:   Thu Jun 14 11:32:21 2012 -0300
+
+    [media] v4l: vb2-dma-contig: let mmap method to use dma_mmap_coherent call
+    
+    Let mmap method to use dma_mmap_coherent call.  Moreover, this patch removes
+    vb2_mmap_pfn_range from videobuf2 helpers as it was suggested by Laurent
+    Pinchart.  The function is no longer used in vb2 code.
+    
+    Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
+    Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
+    Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+    Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
+    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
+
+--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
++++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
+@@ -186,6 +186,22 @@ static void *vb2_dc_alloc(void *alloc_ct
+ 	return buf;
+ }
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,9,0))
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0))
++static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
++{
++	struct vb2_dc_buf *buf = buf_priv;
++
++	if (!buf) {
++		printk(KERN_ERR "No buffer to map\n");
++		return -EINVAL;
++	}
++
++	return vb2_mmap_pfn_range(vma, buf->dma_addr, buf->size,
++				  &vb2_common_vm_ops, &buf->handler);
++}
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)) */
++#else
+ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
+ {
+ 	struct vb2_dc_buf *buf = buf_priv;
+@@ -222,6 +238,7 @@ static int vb2_dc_mmap(void *buf_priv, s
+ 
+ 	return 0;
+ }
++#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,9,0)) */
+ 
+ /*********************************************/
+ /*         DMABUF ops for exporters          */
diff --git a/patches/collateral-evolutions/media/0003-technisat-usb2-led-rename.patch b/patches/collateral-evolutions/media/0003-technisat-usb2-led-rename.patch
new file mode 100644
index 0000000..ddfc32e
--- /dev/null
+++ b/patches/collateral-evolutions/media/0003-technisat-usb2-led-rename.patch
@@ -0,0 +1,83 @@
+This clashes with include/linux/leds.h namespace, fix this and
+also send this upstream eventually.
+
+--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
++++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
+@@ -214,10 +214,10 @@ static void technisat_usb2_frontend_reset(struct usb_device *udev)
+ 
+ /* LED control */
+ enum technisat_usb2_led_state {
+-	LED_OFF,
+-	LED_BLINK,
+-	LED_ON,
+-	LED_UNDEFINED
++	TECH_LED_OFF,
++	TECH_LED_BLINK,
++	TECH_LED_ON,
++	TECH_LED_UNDEFINED
+ };
+ 
+ static int technisat_usb2_set_led(struct dvb_usb_device *d, int red, enum technisat_usb2_led_state state)
+@@ -229,14 +229,14 @@ static int technisat_usb2_set_led(struct dvb_usb_device *d, int red, enum techni
+ 		0
+ 	};
+ 
+-	if (disable_led_control && state != LED_OFF)
++	if (disable_led_control && state != TECH_LED_OFF)
+ 		return 0;
+ 
+ 	switch (state) {
+-	case LED_ON:
++	case TECH_LED_ON:
+ 		led[1] = 0x82;
+ 		break;
+-	case LED_BLINK:
++	case TECH_LED_BLINK:
+ 		led[1] = 0x82;
+ 		if (red) {
+ 			led[2] = 0x02;
+@@ -251,7 +251,7 @@ static int technisat_usb2_set_led(struct dvb_usb_device *d, int red, enum techni
+ 		break;
+ 
+ 	default:
+-	case LED_OFF:
++	case TECH_LED_OFF:
+ 		led[1] = 0x80;
+ 		break;
+ 	}
+@@ -310,11 +310,11 @@ static void technisat_usb2_green_led_control(struct work_struct *work)
+ 				goto schedule;
+ 
+ 			if (ber > 1000)
+-				technisat_usb2_set_led(state->dev, 0, LED_BLINK);
++				technisat_usb2_set_led(state->dev, 0, TECH_LED_BLINK);
+ 			else
+-				technisat_usb2_set_led(state->dev, 0, LED_ON);
++				technisat_usb2_set_led(state->dev, 0, TECH_LED_ON);
+ 		} else
+-			technisat_usb2_set_led(state->dev, 0, LED_OFF);
++			technisat_usb2_set_led(state->dev, 0, TECH_LED_OFF);
+ 	}
+ 
+ schedule:
+@@ -365,9 +365,9 @@ static int technisat_usb2_power_ctrl(struct dvb_usb_device *d, int level)
+ 		return 0;
+ 
+ 	/* green led is turned off in any case - will be turned on when tuning */
+-	technisat_usb2_set_led(d, 0, LED_OFF);
++	technisat_usb2_set_led(d, 0, TECH_LED_OFF);
+ 	/* red led is turned on all the time */
+-	technisat_usb2_set_led(d, 1, LED_ON);
++	technisat_usb2_set_led(d, 1, TECH_LED_ON);
+ 	return 0;
+ }
+ 
+@@ -667,7 +667,7 @@ static int technisat_usb2_rc_query(struct dvb_usb_device *d)
+ 		return 0;
+ 
+ 	if (!disable_led_control)
+-		technisat_usb2_set_led(d, 1, LED_BLINK);
++		technisat_usb2_set_led(d, 1, TECH_LED_BLINK);
+ 
+ 	return 0;
+ }
-- 
1.7.10.4

