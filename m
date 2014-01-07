Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbaAGUZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 15:25:58 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:49831 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbaAGUZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 15:25:49 -0500
Message-ID: <52CC62B7.3030004@gmail.com>
Date: Tue, 07 Jan 2014 22:25:27 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: "pali.rohar@gmail.com" <pali.rohar@gmail.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: OMAPDSS: DISPC: horizontal timing too tight errors
References: <52CA7ABB.4010401@gmail.com> <52CBF476.3070306@ti.com>
In-Reply-To: <52CBF476.3070306@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.01.2014 14:35, Tomi Valkeinen wrote:
> On 2014-01-06 11:43, Ivaylo Dimitrov wrote:
>> Hi,
>>
>> commit 7faa92339bbb1e6b9a80983b206642517327eb75 "OMAPDSS: DISPC: Handle
>> synclost errors in OMAP3" introduces some limits check to prevent
>> SYNCLOST errors on OMAP3 in a specific usecase. The problem I see here
>> (on Nokia N900, Maemo 5, linux 3.13-rc6, DSP accel video decoding) is
>> that those checks effectively prevent fullscreen video playback of
>> anything above lets say 640x350 with "horizontal timing too tight"
>> errors spit in dmesg log. If I hack check_horiz_timing_omap3 function to
>> always return true, I can happily play videos up to (and including) 720p
>> resolutions, with no SYNCLOST errors.
>
> I never worked with the patch in question, but my understanding is that
> the core issue is quite difficult to solve optimally for all cases.
> There are so many variables involved. So it may well be that the patch
> in question does it a bit over-safely. Then again, it might as well have
> a bug =).
>
> One option is also to increase the blanking timings and pixel clock,
> presuming the panel is fine with it. That would allow some more time for
> the DISPC to manage scaling.
>
> So are you saying that you can't even play any video in the LCD's native
> resolution (i.e. no scaling needed) with fullscreen?
>
>> So, a couple of questions:
>>
>> Where do the values in static const u8 limits[3] come from? Are those
>> documented somewhere?
>
> If I remember right, these horizontal check timings information came
> from some non-public TI guides. Not from the TRM.
>
>> Commit message says "This code is written based on code written by Ville
>> Syrjälä <ville.syrjala@nokia.com> in Linux OMAP kernel.", is that code
>> publicly available and where (if it is).
>
> It should be in the Nokia's kernel for N9.
>
>> Besides compiling DSS driver with DEBUG enabled and providing the log
>> (yeah, I know I should've done it already and have the logs included in
>> this mail, but... :) ), is there anything else I can do to find the
>> culprit for those errors.
>
> You could look at the original patch in the Nokia kernel to see if the
> mainline version is ok. Or maybe even better, try the same use case on
> Nokia's kernel to see if it works.
>
>   Tomi
>
>

Ok, after looking at what both N900 and N9 Nokia kernels do, I came up 
with the patch bellow. If you are ok with the changes, I'll submit the 
patch as it should. With that patch I tried more than 20 videos of 
different resolutions(including 720p), not a single failure :) . 
Basically it changes the core clock calculation to be done in the same 
way as in the Nokia kernels.

Regards,
Ivo



diff --git a/drivers/video/omap2/dss/dispc.c 
b/drivers/video/omap2/dss/dispc.c
index 67e413e..ab5aa05 100644
--- a/drivers/video/omap2/dss/dispc.c
+++ b/drivers/video/omap2/dss/dispc.c
@@ -1999,7 +1999,8 @@ static void calc_tiler_rotation_offset(u16 
screen_width, u16 width,
   */
  static int check_horiz_timing_omap3(unsigned long pclk, unsigned long 
lclk,
  		const struct omap_video_timings *t, u16 pos_x,
-		u16 width, u16 height, u16 out_width, u16 out_height)
+		u16 width, u16 height, u16 out_width, u16 out_height,
+				    bool five_taps)
  {
  	const int ds = DIV_ROUND_UP(height, out_height);
  	unsigned long nonactive;
@@ -2019,6 +2020,10 @@ static int check_horiz_timing_omap3(unsigned long 
pclk, unsigned long lclk,
  	if (blank <= limits[i])
  		return -EINVAL;

+	/* FIXME add checks for 3-tap filter once the limitations are known */
+	if (!five_taps)
+		return 0;
+	
  	/*
  	 * Pixel data should be prepared before visible display point starts.
  	 * So, atleast DS-2 lines must have already been fetched by DISPC
@@ -2191,24 +2196,33 @@ static int dispc_ovl_calc_scaling_34xx(unsigned 
long pclk, unsigned long lclk,
  	const int maxsinglelinewidth =
  			dss_feat_get_param_max(FEAT_PARAM_LINEWIDTH);

+	*five_taps = height > out_height;
+
  	do {
  		in_height = DIV_ROUND_UP(height, *decim_y);
  		in_width = DIV_ROUND_UP(width, *decim_x);
-		*core_clk = calc_core_clk_five_taps(pclk, mgr_timings,
-			in_width, in_height, out_width, out_height, color_mode);
-
-		error = check_horiz_timing_omap3(pclk, lclk, mgr_timings,
-				pos_x, in_width, in_height, out_width,
-				out_height);

  		if (in_width > maxsinglelinewidth)
  			if (in_height > out_height &&
  						in_height < out_height * 2)
  				*five_taps = false;
-		if (!*five_taps)
+again:
+		if(*five_taps)
+			*core_clk = calc_core_clk_five_taps(pclk, mgr_timings,
+						in_width, in_height, out_width,
+						out_height, color_mode);
+		else
  			*core_clk = dispc.feat->calc_core_clk(pclk, in_width,
-					in_height, out_width, out_height,
-					mem_to_mem);
+				in_height, out_width, out_height,
+				mem_to_mem);
+
+		error = check_horiz_timing_omap3(pclk, lclk, mgr_timings,
+				pos_x, in_width, in_height, out_width,
+				out_height, *five_taps);
+		if(*five_taps && error) {
+			*five_taps = false;
+			goto again;
+		}

  		error = (error || in_width > maxsinglelinewidth * 2 ||
  			(in_width > maxsinglelinewidth && *five_taps) ||
@@ -2226,7 +2240,7 @@ static int dispc_ovl_calc_scaling_34xx(unsigned 
long pclk, unsigned long lclk,
  	} while (*decim_x <= *x_predecim && *decim_y <= *y_predecim && error);

  	if (check_horiz_timing_omap3(pclk, lclk, mgr_timings, pos_x, width,
-				height, out_width, out_height)){
+				height, out_width, out_height, *five_taps)){
  			DSSERR("horizontal timing too tight\n");
  			return -EINVAL;
  	}

