Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965067Ab3DJRFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:05:44 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:60627 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934082Ab3DJRFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:05:43 -0400
Message-ID: <1365613531.4235.20.camel@jlt4.sipsolutions.net>
Subject: Re: mac80211_hwsim: Check return value of driver_register
From: Johannes Berg <johannes@sipsolutions.net>
To: Martin Pitt <martin.pitt@ubuntu.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 19:05:31 +0200
In-Reply-To: <20130410164027.GB2884@piware.de>
References: <20130410164027.GB2884@piware.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 18:40 +0200, Martin Pitt wrote:
> If driver_register() fails, properly exit with the same error code.
> 
> Signed-off-by: Martin Pitt <martin.pitt@ubuntu.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 57361c3..a2224b7 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -2183,7 +2183,12 @@ static int __init init_mac80211_hwsim(void)
>  	if (IS_ERR(hwsim_class))
>  		return PTR_ERR(hwsim_class);
>  
> -	driver_register(&mac80211_hwsim_driver);
> +	err = driver_register(&mac80211_hwsim_driver);
> +	if (err != 0) {
> +		printk(KERN_DEBUG
> +		       "mac80211_hwsim: driver_register failed (%d)\n", err);
> +		return err;
> +	}

Except you just leaked the class... I have a different fix already
anyway:

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 9a0d526..b5117f5 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2191,11 +2191,15 @@ static int __init init_mac80211_hwsim(void)
 	spin_lock_init(&hwsim_radio_lock);
 	INIT_LIST_HEAD(&hwsim_radios);
 
-	hwsim_class = class_create(THIS_MODULE, "mac80211_hwsim");
-	if (IS_ERR(hwsim_class))
-		return PTR_ERR(hwsim_class);
+	err = driver_register(&mac80211_hwsim_driver);
+	if (err)
+		return err;
 
-	driver_register(&mac80211_hwsim_driver);
+	hwsim_class = class_create(THIS_MODULE, "mac80211_hwsim");
+	if (IS_ERR(hwsim_class)) {
+		err = PTR_ERR(hwsim_class);
+		goto failed_unregister_driver;
+	}
 
 	memset(addr, 0, ETH_ALEN);
 	addr[0] = 0x02;
@@ -2529,6 +2533,7 @@ failed_drvdata:
 	ieee80211_free_hw(hw);
 failed:
 	mac80211_hwsim_free();
+failed_unregister_driver:
 	driver_unregister(&mac80211_hwsim_driver);
 	return err;
 }


johannes

