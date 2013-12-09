Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131Ab3LIQzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:55:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932795Ab3LIQzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:55:12 -0500
Message-ID: <1386607847.24473.10.camel@dcbw.foobar.com>
Subject: Re: [PATCH v2 14/16] wl1251: Add sysfs file tx_mgmt_frm_rate for
 setting rate
From: Dan Williams <dcbw@redhat.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>
Date: Mon, 09 Dec 2013 10:50:47 -0600
In-Reply-To: <1386494714-21070-15-git-send-email-pali.rohar@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
	 <1386494714-21070-15-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-08 at 10:25 +0100, Pali Rohár wrote:
> This patch adds support for configuring reg domains.
> Patch was extracted from Maemo 2.6.28 kernel.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  drivers/net/wireless/ti/wl1251/main.c |  152 +++++++++++++++++++++++++++++++++
>  1 file changed, 152 insertions(+)

Isn't this supposed to be done automatically by the rate control
modules?  Seems pretty wrong to have it done via a sysfs file.  If the
maemo code was twiddling the TX rate for management frames so that it
could get more reliable DHCP or 802.1x, we have better nl80211
mechanisms for that now.

Also, the patch description is wrong.  This doesn't really add support
for "configuring reg domains" at all.

Dan

> diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
> index 382dedf..42730b7 100644
> --- a/drivers/net/wireless/ti/wl1251/main.c
> +++ b/drivers/net/wireless/ti/wl1251/main.c
> @@ -1377,6 +1377,147 @@ static const struct ieee80211_ops wl1251_ops = {
>  	.get_survey = wl1251_op_get_survey,
>  };
>  
> +static ssize_t wl1251_sysfs_show_tx_mgmt_frm_rate(struct device *dev,
> +						  struct device_attribute *attr,
> +						  char *buf)
> +{
> +	struct wl1251 *wl = dev_get_drvdata(dev);
> +	ssize_t len;
> +	int val;
> +
> +	/* FIXME: what's the maximum length of buf? page size?*/
> +	len = 500;
> +
> +	switch (wl->tx_mgmt_frm_rate) {
> +		/* skip 1 and 12 Mbps because they have same value 0x0a */
> +	case RATE_2MBPS:
> +		val = 20;
> +		break;
> +	case RATE_5_5MBPS:
> +		val = 55;
> +		break;
> +	case RATE_11MBPS:
> +		val = 110;
> +		break;
> +	case RATE_6MBPS:
> +		val = 60;
> +		break;
> +	case RATE_9MBPS:
> +		val = 90;
> +		break;
> +	case RATE_12MBPS:
> +		val = 120;
> +		break;
> +	case RATE_18MBPS:
> +		val = 180;
> +		break;
> +	case RATE_24MBPS:
> +		val = 240;
> +		break;
> +	case RATE_36MBPS:
> +		val = 360;
> +		break;
> +	case RATE_48MBPS:
> +		val = 480;
> +		break;
> +	case RATE_54MBPS:
> +		val = 540;
> +		break;
> +	default:
> +		val = 10;
> +	}
> +
> +	/* for 1 and 12 Mbps we have to check the modulation */
> +	if (wl->tx_mgmt_frm_rate == RATE_1MBPS) {
> +		switch (wl->tx_mgmt_frm_rate) {
> +		case CCK_LONG:
> +			val = 10;
> +			break;
> +		case OFDM:
> +			val = 120;
> +			break;
> +		default:
> +			val = 10;
> +			break;
> +		}
> +	}
> +	len = snprintf(buf, len, "%d", val);
> +
> +	return len;
> +}
> +
> +static ssize_t wl1251_sysfs_store_tx_mgmt_frm_rate(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct wl1251 *wl = dev_get_drvdata(dev);
> +	unsigned long res;
> +	int ret;
> +
> +	ret = strict_strtoul(buf, 10, &res);
> +
> +	if (ret < 0) {
> +		wl1251_warning("incorrect value written to tx_mgmt_frm_rate");
> +		return 0;
> +	}
> +
> +	switch (res) {
> +	case 10:
> +		wl->tx_mgmt_frm_rate = RATE_1MBPS;
> +		wl->tx_mgmt_frm_mod = CCK_LONG;
> +		break;
> +	case 20:
> +		wl->tx_mgmt_frm_rate = RATE_2MBPS;
> +		wl->tx_mgmt_frm_mod = CCK_LONG;
> +		break;
> +	case 55:
> +		wl->tx_mgmt_frm_rate = RATE_5_5MBPS;
> +		wl->tx_mgmt_frm_mod = CCK_LONG;
> +		break;
> +	case 110:
> +		wl->tx_mgmt_frm_rate = RATE_11MBPS;
> +		wl->tx_mgmt_frm_mod = CCK_LONG;
> +		break;
> +	case 60:
> +		wl->tx_mgmt_frm_rate = RATE_6MBPS;
> +		wl->tx_mgmt_frm_mod = OFDM;
> +		break;
> +	case 90:
> +		wl->tx_mgmt_frm_rate = RATE_9MBPS;
> +		wl->tx_mgmt_frm_mod = OFDM;
> +		break;
> +	case 120:
> +		wl->tx_mgmt_frm_rate = RATE_12MBPS;
> +		wl->tx_mgmt_frm_mod = OFDM;
> +		break;
> +	case 180:
> +		wl->tx_mgmt_frm_rate = RATE_18MBPS;
> +		wl->tx_mgmt_frm_mod = OFDM;
> +		break;
> +	case 240:
> +		wl->tx_mgmt_frm_rate = RATE_24MBPS;
> +		wl->tx_mgmt_frm_mod = OFDM;
> +		break;
> +	case 360:
> +		wl->tx_mgmt_frm_rate = RATE_36MBPS;
> +		wl->tx_mgmt_frm_mod = OFDM;
> +		break;
> +	case 480:
> +		wl->tx_mgmt_frm_rate = RATE_48MBPS;
> +		wl->tx_mgmt_frm_mod = OFDM;
> +		break;
> +	case 540:
> +		wl->tx_mgmt_frm_rate = RATE_54MBPS;
> +		wl->tx_mgmt_frm_mod = OFDM;
> +		break;
> +	default:
> +		wl1251_warning("incorrect value written to tx_mgmt_frm_rate");
> +		return 0;
> +	}
> +
> +	return count;
> +}
> +
>  static ssize_t wl1251_sysfs_show_bt_coex_mode(struct device *dev,
>  					      struct device_attribute *attr,
>  					      char *buf)
> @@ -1445,6 +1586,10 @@ out:
>  	return count;
>  }
>  
> +static DEVICE_ATTR(tx_mgmt_frm_rate, S_IRUGO | S_IWUSR,
> +		   wl1251_sysfs_show_tx_mgmt_frm_rate,
> +		   wl1251_sysfs_store_tx_mgmt_frm_rate);
> +
>  static DEVICE_ATTR(bt_coex_mode, S_IRUGO | S_IWUSR,
>  		   wl1251_sysfs_show_bt_coex_mode,
>  		   wl1251_sysfs_store_bt_coex_mode);
> @@ -1585,6 +1730,13 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
>  	}
>  	dev_set_drvdata(&wl1251_device.dev, wl);
>  
> +	/* Create sysfs file tx_mgmt_frm_rate */
> +	ret = device_create_file(&wl1251_device.dev,
> +				 &dev_attr_tx_mgmt_frm_rate);
> +	if (ret < 0) {
> +		wl1251_error("failed to create sysfs file tx_mgmt_frm_rate");
> +		goto out;
> +	}
>  
>  	/* Create sysfs file to control bt coex state */
>  	ret = device_create_file(&wl1251_device.dev, &dev_attr_bt_coex_mode);


