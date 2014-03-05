Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbaCEVyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:54:50 -0500
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:60953 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753236AbaCEVys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:54:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:2:41:355:379:541:599:800:857:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:3872:3874:4117:4321:4605:5007:7652:7903:10004:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beds28_46aa74f080f10
X-Filterd-Recvd-Size: 6994
Message-ID: <1394056484.12070.20.camel@joe-AO722>
Subject: Re: [PATCH 1/6] rtc: pm8xxx: fixup checkpatch/style issues
From: Joe Perches <joe@perches.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Josh Cartwright <joshc@codeaurora.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-arm-msm@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Date: Wed, 05 Mar 2014 13:54:44 -0800
In-Reply-To: <531790E5.8020204@codeaurora.org>
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
	 <1394047776-13827-2-git-send-email-joshc@codeaurora.org>
	 <531790E5.8020204@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 13:02 -0800, Stephen Boyd wrote:
> On 03/05/14 11:29, Josh Cartwright wrote:
> > Before performing additional cleanups to this driver, do the easy
> > cleanups first.
> >
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> 
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> > @@ -253,7 +253,7 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
> >  
> >  	ctrl_reg = rtc_dd->ctrl_reg;
> >  	ctrl_reg = alarm->enabled ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
> > -					(ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
> > +				    (ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
> >  
> >  	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
> >  	if (rc < 0) {
> 
> This could be better style with more lines:
> 
> if (alarm->enabled)
>     ctrl_reg |= PM8xxx_RTC_ALARM_ENABLE;
> else
>     ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
> 

I agree.

Maybe something like a set_or_clear_bits macro similar to clamp
could be useful.

Maybe:

#define set_or_clear_bits(value, test, bits)	\
({						\
	typeof value _value;			\
	if (test)				\
		_value = (value) | (bits);	\
	else					\
		_value = (value) & (~(bits));	\
	_value;					\
})

so the code above could be something like:

	ctrl_reg = set_or_clear_bits(ctrl_reg, alarm->enabled, PM8xxx_RTC_ALARM_ENABLE);

(or some other better macro name, or maybe not type
 the value name twice and have it set by the macro)

There's at least a few dozen like alarm->enabled use
above that could be converted in drivers/.

( a few false positives here too )

$ grep-2.5.4 -rP --include=*.[ch] "([\w\.\>\[\]\-]+)\s*=[^;\?]+\?\s*\(?\s*\1\s*[\&\|][^;]+;" drivers/
drivers/input/misc/twl4030-vibra.c:		reg = (dir) ? (reg | TWL4030_VIBRA_DIR) :
			(reg & ~TWL4030_VIBRA_DIR);
drivers/ata/libata-scsi.c:	tf->device = dev->devno ?
		tf->device | ATA_DEV1 : tf->device & ~ATA_DEV1;
drivers/ata/pata_samsung_cf.c:	reg = mode ? (reg & ~S3C_ATA_CFG_SWAP) : (reg | S3C_ATA_CFG_SWAP);
drivers/ata/pata_samsung_cf.c:	temp = state ? (temp | 1) : (temp & ~1);
drivers/staging/iio/accel/lis3l02dq_core.c:		control = val & 0x3f ?
			(control | LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT) :
			(control & ~LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT);
drivers/staging/media/sn9c102/sn9c102_core.c:	rect->left = (s->_rect.left & 1L) ? rect->left | 1L : rect->left & ~1L;
drivers/staging/media/sn9c102/sn9c102_core.c:	rect->top = (s->_rect.top & 1L) ? rect->top | 1L : rect->top & ~1L;
drivers/message/fusion/mptsas.c:	ioc->device_missing_delay = (device_missing_delay & MPI_SAS_IOUNIT1_REPORT_MISSING_UNIT_16) ?
	    (device_missing_delay & MPI_SAS_IOUNIT1_REPORT_MISSING_TIMEOUT_MASK) * 16 :
	    device_missing_delay & MPI_SAS_IOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
drivers/gpio/gpio-max732x.c:	reg_out = (val) ? reg_out | mask : reg_out & ~mask;
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:	mac_filters->ucast_drop_all = drop_all_ucast ?
		mac_filters->ucast_drop_all | mask :
		mac_filters->ucast_drop_all & ~mask;
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:	mac_filters->mcast_drop_all = drop_all_mcast ?
		mac_filters->mcast_drop_all | mask :
		mac_filters->mcast_drop_all & ~mask;
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:	mac_filters->ucast_accept_all = accp_all_ucast ?
		mac_filters->ucast_accept_all | mask :
		mac_filters->ucast_accept_all & ~mask;
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:	mac_filters->mcast_accept_all = accp_all_mcast ?
		mac_filters->mcast_accept_all | mask :
		mac_filters->mcast_accept_all & ~mask;
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:	mac_filters->bcast_accept_all = accp_all_bcast ?
		mac_filters->bcast_accept_all | mask :
		mac_filters->bcast_accept_all & ~mask;
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c:	mac_filters->unmatched_unicast = unmatched_unicast ?
		mac_filters->unmatched_unicast | mask :
		mac_filters->unmatched_unicast & ~mask;
drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h:				reg_bit_map = new_cos ?
					      (reg_bit_map | q_bit_map) :
					      (reg_bit_map & (~q_bit_map));
drivers/ide/pdc202xx_old.c:		word_count = (rq_data_dir(rq) == READ) ?
					word_count | 0x05000000 :
					word_count | 0x06000000;
drivers/spi/spi-fsl-spi.c:		slvsel = on ? (slvsel | (1 << cs)) : (slvsel & ~(1 << cs));
drivers/rtc/rtc-pm8xxx.c:	ctrl_reg = alarm->enabled ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
					(ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
drivers/rtc/rtc-pm8xxx.c:	ctrl_reg = (enable) ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
				(ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
drivers/platform/x86/acer-wmi.c:	set_params.devices = (value) ? (devices | device) : (devices & ~device);
drivers/media/i2c/ov9650.c:		reg = awb ? reg | REG_COM8 : reg & ~REG_COM8;
drivers/media/i2c/ov9650.c:	com14 = value ? com14 | COM14_EDGE_EN : com14 & ~COM14_EDGE_EN;
drivers/media/i2c/ov9650.c:	reg = value ? reg | COM23_TEST_MODE : reg & ~COM23_TEST_MODE;
drivers/media/i2c/s5k6aa.c:		reg = awb ? reg | AALG_WB_EN_MASK : reg & ~AALG_WB_EN_MASK;
drivers/media/usb/dvb-usb-v2/lmedm04.c:	cold = (cold > 0) ? (cold & 1) : 0;
drivers/media/usb/gspca/m5602/m5602_s5k83a.c:	data[0] = (vflip) ? data[0] | 0x40 : data[0];
drivers/media/usb/gspca/m5602/m5602_s5k83a.c:	data[0] = (hflip) ? data[0] | 0x80 : data[0];
drivers/media/dvb-frontends/dib3000mb.c:	pid = (onoff ? pid | DIB3000_ACTIVATE_PID_FILTERING : 0);
drivers/video/s1d13xxxfb.c:	regno=((regno & 1) ? (regno & ~1L) : (regno + 1));
drivers/video/s1d13xxxfb.c:	regno=((regno & 1) ? (regno & ~1L) : (regno + 1));
drivers/video/i810/i810_main.c:	val = (mode == OFF) ? val | SCR_OFF :
		val & ~SCR_OFF;
drivers/video/i810/i810_main.c:	reg = (mode == OFF) ? reg & ~0x80 :
		reg | 0x80;
drivers/video/i810/i810_main.c:	temp = (mode == ON) ? temp | CURSOR_ENABLE_MASK :
		temp & ~CURSOR_ENABLE_MASK;
drivers/atm/eni.c:			tonga = (address >> j) & 1 ? tonga | SEPROM_DATA :
			    tonga & ~SEPROM_DATA;


