Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161768AbaKNSrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:47:22 -0500
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:52132 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161282AbaKNSrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:47:20 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1461:1515:1516:1518:1535:1544:1593:1594:1711:1730:1747:1777:1792:1801:2194:2199:2393:2559:2562:2729:2828:3138:3139:3140:3141:3142:3354:3622:3653:3865:3866:3867:3871:3874:4225:4321:4605:4823:5007:6261:7875:7901:7903:8603:10004:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12740:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: quiet62_79d98e9fada33
X-Filterd-Recvd-Size: 5256
Message-ID: <1415990835.5912.20.camel@perches.com>
Subject: Re: [PATCH 1/1 net-next] net: dsa: replace count*size kmalloc by
 kmalloc_array
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Date: Fri, 14 Nov 2014 10:47:15 -0800
In-Reply-To: <1415990202-28673-1-git-send-email-fabf@skynet.be>
References: <1415990202-28673-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 19:36 +0100, Fabian Frederick wrote:
> kmalloc_array manages count*sizeof overflow.

Fundamentally correct, but is this necessary or useful?
sizeof(s8) isn't often going to be anything other than 1.

Would the kernel even work without that assumption?


> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
[]
> @@ -526,7 +526,8 @@ static int dsa_of_setup_routing_table(struct dsa_platform_data *pd,
>  
>  	/* First time routing table allocation */
>  	if (!cd->rtable) {
> -		cd->rtable = kmalloc(pd->nr_chips * sizeof(s8), GFP_KERNEL);
> +		cd->rtable = kmalloc_array(pd->nr_chips, sizeof(s8),
> +					   GFP_KERNEL);
>  		if (!cd->rtable)
>  			return -ENOMEM;
>  

Maybe all of these could be simplified

$ git grep -E "\*\s*sizeof\s*\(\s*[us]8\s*\)"
arch/arm/common/edma.c:                                   (edma_cc->num_tc + 1) * sizeof(s8),
drivers/acpi/utils.c:                               (element->buffer.length * sizeof(u8));
drivers/acpi/utils.c:                           tail += element->buffer.length * sizeof(u8);
drivers/char/tpm/tpm_i2c_stm_st33.c:        kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
drivers/char/tpm/tpm_i2c_stm_st33.c:        kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
drivers/gpu/drm/r128/r128_state.c:      mask_size = depth->n * sizeof(u8);
drivers/gpu/drm/r128/r128_state.c:              mask_size = depth->n * sizeof(u8);
drivers/iio/common/st_sensors/st_sensors_spi.c: memcpy(data, tb->rx_buf, len*sizeof(u8));
drivers/infiniband/hw/amso1100/c2_mq.h: u8 pad[64 - sizeof(u16) - 2 * sizeof(u8) - sizeof(u32) - sizeof(u16)];
drivers/input/tablet/aiptek.c:  const int sizeof_buf = 3 * sizeof(u8);
drivers/input/tablet/aiptek.c:  const int sizeof_buf = 3 * sizeof(u8);
drivers/md/dm-crypt.c:  memset(&cc->key, 0, cc->key_size * sizeof(u8));
drivers/md/dm-crypt.c:  cc = kzalloc(sizeof(*cc) + key_size * sizeof(u8), GFP_KERNEL);
drivers/media/dvb-frontends/dib7000p.c: tx = kzalloc(2*sizeof(u8), GFP_KERNEL);
drivers/media/dvb-frontends/dib7000p.c: rx = kzalloc(2*sizeof(u8), GFP_KERNEL);
drivers/media/dvb-frontends/dib8000.c:  client.i2c_write_buffer = kzalloc(4 * sizeof(u8), GFP_KERNEL);
drivers/media/dvb-frontends/dib8000.c:  client.i2c_read_buffer = kzalloc(4 * sizeof(u8), GFP_KERNEL);
drivers/media/dvb-frontends/dib9000.c:  client.i2c_write_buffer = kzalloc(4 * sizeof(u8), GFP_KERNEL);
drivers/media/dvb-frontends/dib9000.c:  client.i2c_read_buffer = kzalloc(4 * sizeof(u8), GFP_KERNEL);
drivers/media/pci/ttpci/av7110_ipack.c: if (!(p->buf = vmalloc(size*sizeof(u8)))) {
drivers/mtd/inftlmount.c:                               s->nb_blocks * sizeof(u8));
drivers/net/wireless/ath/ath10k/htt.h:   *  b) num_chars * sizeof(u8) aligned to 4bytes */
drivers/net/wireless/b43/ppr.c: BUILD_BUG_ON(sizeof(struct b43_ppr) != B43_PPR_RATES_NUM * sizeof(u8));
drivers/net/wireless/iwlwifi/pcie/trans.c:                     trans_pcie->n_no_reclaim_cmds * sizeof(u8));
drivers/net/wireless/rtlwifi/efuse.c:   memset(data, 0xff, PGPKT_DATA_SIZE * sizeof(u8));
drivers/net/wireless/rtlwifi/efuse.c:   memset(tmpdata, 0xff, PGPKT_DATA_SIZE * sizeof(u8));
drivers/net/wireless/rtlwifi/efuse.c:   u8 originaldata[8 * sizeof(u8)];
drivers/net/wireless/rtlwifi/efuse.c:   u8 originaldata[8 * sizeof(u8)];
drivers/net/wireless/rtlwifi/efuse.c:           memset(originaldata, 0xff,  8 * sizeof(u8));
drivers/net/wireless/rtlwifi/efuse.c:   memset(target_pkt.data, 0xFF,  8 * sizeof(u8));
drivers/power/ds2781_battery.c: ret = w1_ds2781_read(dev_info, val, DS2781_VOLT_MSB, 2 * sizeof(u8));
drivers/power/ds2781_battery.c: ret = w1_ds2781_read(dev_info, val, DS2781_TEMP_MSB, 2 * sizeof(u8));
drivers/rtc/rtc-pcf2123.c:      ret = spi_write(spi, txbuf, 2 * sizeof(u8));
drivers/rtc/rtc-pcf2123.c:      ret = spi_write(spi, txbuf, 2 * sizeof(u8));
drivers/rtc/rtc-pcf2123.c:      ret = spi_write_then_read(spi, txbuf, 1 * sizeof(u8),
drivers/rtc/rtc-pcf2123.c:                                      rxbuf, 2 * sizeof(u8));
drivers/thermal/x86_pkg_temp_thermal.c:                 (max_phy_id+1) * sizeof(u8), GFP_ATOMIC);
fs/compat_ioctl.c:      if (__copy_in_user(&tdata->read_write, &udata->read_write, 2 * sizeof(u8)))
net/dsa/dsa.c:          cd->rtable = kmalloc(pd->nr_chips * sizeof(s8), GFP_KERNEL);
net/dsa/dsa.c:          memset(cd->rtable, -1, pd->nr_chips * sizeof(s8));


