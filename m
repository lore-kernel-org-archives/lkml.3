Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaAWLwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 06:52:24 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46322 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751587AbaAWLwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 06:52:15 -0500
Date: Thu, 23 Jan 2014 11:52:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Mark Rutland <mark.rutland@arm.com>,
        linux-pwm@vger.kernel.org, Rob Landley <rob@landley.net>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 2/2] pwm: imx: support polarity inversion
Message-ID: <20140123115203.GV15937@n2100.arm.linux.org.uk>
References: <1389859585-14006-1-git-send-email-LW@KARO-electronics.de> <1389859585-14006-3-git-send-email-LW@KARO-electronics.de> <20140116160356.GY16215@pengutronix.de> <20140123083714.3c6e86ae@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140123083714.3c6e86ae@ipc1.ka-ro>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 08:37:14AM +0100, Lothar Waßmann wrote:
> This wouldn't buy much without a material change to of_pwm_get().
> The function of_parse_phandle_with_args() called by of_pwm_get()
> requires the number of args in the pwms property be greater or equal to
> the #pwm-cells property in the pwm node. Thus, the interesting case of
> having #pwm-cells = <3> without changing the existing users is
> prohibited by of_parse_phandle_with_args().

I really don't think that's a problem we need to be concerned with at
the moment.  What we need is for the kernel to be able to parse files
with #pwm-cells = <2> with the pwms property containing two arguments,
and when they're updated to #pwm-cells = <3> with the pwms property
containing three arguments.

Yes, that means all the board dt files need to be updated at the same
time to include the additional argument, but I don't see that as a big
problem.

What we do need to do is to adjust the PWM parsing code such that it's
possible to use either specification without causing any side effects.

I would test this, but as u-boot is rather fscked at the moment and the
networking has broken on my cubox-i as a result... and it seems that the
u-boot developers have pissed off cubox-i u-boot hackers soo much that
they've dropped u-boot in favour of barebox...

 drivers/pwm/core.c  | 59 +++++++++++++++++++++++++++++------------------------
 include/linux/pwm.h |  2 ++
 2 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 2ca95042a0b9..40adbce8ef0c 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -132,14 +132,11 @@ static int pwm_device_request(struct pwm_device *pwm, const char *label)
 }
 
 struct pwm_device *
-of_pwm_xlate_with_flags(struct pwm_chip *pc, const struct of_phandle_args *args)
+of_pwm_xlate(struct pwm_chip *pc, const struct of_phandle_args *args)
 {
 	struct pwm_device *pwm;
 
-	if (pc->of_pwm_n_cells < 3)
-		return ERR_PTR(-EINVAL);
-
-	if (args->args[0] >= pc->npwm)
+	if (args->args_count < 2)
 		return ERR_PTR(-EINVAL);
 
 	pwm = pwm_request_from_chip(pc, args->args[0], NULL);
@@ -148,33 +145,45 @@ of_pwm_xlate_with_flags(struct pwm_chip *pc, const struct of_phandle_args *args)
 
 	pwm_set_period(pwm, args->args[1]);
 
-	if (args->args[2] & PWM_POLARITY_INVERTED)
-		pwm_set_polarity(pwm, PWM_POLARITY_INVERSED);
-	else
-		pwm_set_polarity(pwm, PWM_POLARITY_NORMAL);
+	if (args->args_count > 2) {
+		int err;
+
+		if (args->args[2] & PWM_POLARITY_INVERTED)
+			err = pwm_set_polarity(pwm, PWM_POLARITY_INVERSED);
+		else
+			err = pwm_set_polarity(pwm, PWM_POLARITY_NORMAL);
+
+		pwm_put(pwm);
+		return ERR_PTR(err);
+	}
 
 	return pwm;
 }
+EXPORT_SYMBOL(of_pwm_xlate);
+
+struct pwm_device *
+of_pwm_xlate_with_flags(struct pwm_chip *pc, const struct of_phandle_args *args)
+{
+	if (pc->of_pwm_n_cells < 3)
+		return ERR_PTR(-EINVAL);
+
+	if (args->args_count != pc->of_pwm_n_cells)
+		return ERR_PTR(-EINVAL);
+
+	return of_pwm_xlate(pc, args);
+}
 EXPORT_SYMBOL_GPL(of_pwm_xlate_with_flags);
 
 static struct pwm_device *
 of_pwm_simple_xlate(struct pwm_chip *pc, const struct of_phandle_args *args)
 {
-	struct pwm_device *pwm;
-
 	if (pc->of_pwm_n_cells < 2)
 		return ERR_PTR(-EINVAL);
 
-	if (args->args[0] >= pc->npwm)
+	if (args->args_count != pc->of_pwm_n_cells)
 		return ERR_PTR(-EINVAL);
 
-	pwm = pwm_request_from_chip(pc, args->args[0], NULL);
-	if (IS_ERR(pwm))
-		return pwm;
-
-	pwm_set_period(pwm, args->args[1]);
-
-	return pwm;
+	return of_pwm_xlate(pc, args);
 }
 
 static void of_pwmchip_add(struct pwm_chip *chip)
@@ -536,16 +545,12 @@ struct pwm_device *of_pwm_get(struct device_node *np, const char *con_id)
 		goto put;
 	}
 
-	if (args.args_count != pc->of_pwm_n_cells) {
-		pr_debug("%s: wrong #pwm-cells for %s\n", np->full_name,
-			 args.np->full_name);
-		pwm = ERR_PTR(-EINVAL);
-		goto put;
-	}
-
 	pwm = pc->of_xlate(pc, &args);
-	if (IS_ERR(pwm))
+	if (IS_ERR(pwm)) {
+		pr_debug("%s: of_xlate failed for %s: %d\n", np->full_name,
+			 args.np->full_name, (int)PTR_ERR(pwm));
 		goto put;
+	}
 
 	/*
 	 * If a consumer name was not given, try to look it up from the
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index f0feafd184a0..14a823f77c31 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -188,6 +188,8 @@ struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
 					 unsigned int index,
 					 const char *label);
 
+struct pwm_device *of_pwm_xlate(struct pwm_chip *pc,
+		const struct of_phandle_args *args);
 struct pwm_device *of_pwm_xlate_with_flags(struct pwm_chip *pc,
 		const struct of_phandle_args *args);
 


-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
