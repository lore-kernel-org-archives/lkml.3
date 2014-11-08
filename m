Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaKHOeP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 09:34:15 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37565 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753716AbaKHOeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 09:34:14 -0500
X-Greylist: delayed 3448 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Nov 2014 09:34:13 EST
Message-ID: <1415454115.1881.3.camel@palomino.walls.org>
Subject: Re: [PATCH 05/11] cx25840/cx18: Use standard ordering of mask and
 shift
From: Andy Walls <awalls@md.metrocast.net>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Date: Sat, 08 Nov 2014 08:41:55 -0500
In-Reply-To: <0f1e7b544283cd5d8ef1ca6f759af5e208dbc2fd.1414387334.git.joe@perches.com>
References: <cover.1414387334.git.joe@perches.com>
	 <0f1e7b544283cd5d8ef1ca6f759af5e208dbc2fd.1414387334.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-08_01:2014-11-07,2014-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1411080124
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-26 at 22:25 -0700, Joe Perches wrote:
> Precedence of & and >> is not the same and is not left to right.
> shift has higher precedence and should be done after the mask.
> 
> This use has a mask then shift which is not the normal style.
> 
> Move the shift before the mask to match nearly all the other
> uses in kernel.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

The patch is technically correct.

Reviewed-by: Andy Walls <awalls@md.metrocast.net>

> ---
>  drivers/media/i2c/cx25840/cx25840-core.c | 12 ++++++------
>  drivers/media/pci/cx18/cx18-av-core.c    | 16 ++++++++--------
>  2 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
> index e453a3f..0327032 100644
> --- a/drivers/media/i2c/cx25840/cx25840-core.c
> +++ b/drivers/media/i2c/cx25840/cx25840-core.c
> @@ -879,7 +879,7 @@ void cx25840_std_setup(struct i2c_client *client)
>  	/* Sets horizontal blanking delay and active lines */
>  	cx25840_write(client, 0x470, hblank);
>  	cx25840_write(client, 0x471,
> -			0xff & (((hblank >> 8) & 0x3) | (hactive << 4)));
> +		      (((hblank >> 8) & 0x3) | (hactive << 4)) & 0xff);
>  	cx25840_write(client, 0x472, hactive >> 4);
>  
>  	/* Sets burst gate delay */
> @@ -888,13 +888,13 @@ void cx25840_std_setup(struct i2c_client *client)
>  	/* Sets vertical blanking delay and active duration */
>  	cx25840_write(client, 0x474, vblank);
>  	cx25840_write(client, 0x475,
> -			0xff & (((vblank >> 8) & 0x3) | (vactive << 4)));
> +		      (((vblank >> 8) & 0x3) | (vactive << 4)) & 0xff);
>  	cx25840_write(client, 0x476, vactive >> 4);
>  	cx25840_write(client, 0x477, vblank656);
>  
>  	/* Sets src decimation rate */
> -	cx25840_write(client, 0x478, 0xff & src_decimation);
> -	cx25840_write(client, 0x479, 0xff & (src_decimation >> 8));
> +	cx25840_write(client, 0x478, src_decimation & 0xff);
> +	cx25840_write(client, 0x479, (src_decimation >> 8) & 0xff);
>  
>  	/* Sets Luma and UV Low pass filters */
>  	cx25840_write(client, 0x47a, luma_lpf << 6 | ((uv_lpf << 4) & 0x30));
> @@ -904,8 +904,8 @@ void cx25840_std_setup(struct i2c_client *client)
>  
>  	/* Sets SC Step*/
>  	cx25840_write(client, 0x47c, sc);
> -	cx25840_write(client, 0x47d, 0xff & sc >> 8);
> -	cx25840_write(client, 0x47e, 0xff & sc >> 16);
> +	cx25840_write(client, 0x47d, (sc >> 8) & 0xff);
> +	cx25840_write(client, 0x47e, (sc >> 16) & 0xff);
>  
>  	/* Sets VBI parameters */
>  	if (std & V4L2_STD_625_50) {
> diff --git a/drivers/media/pci/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
> index 2d3afe0..45be26c 100644
> --- a/drivers/media/pci/cx18/cx18-av-core.c
> +++ b/drivers/media/pci/cx18/cx18-av-core.c
> @@ -490,8 +490,8 @@ void cx18_av_std_setup(struct cx18 *cx)
>  
>  	/* Sets horizontal blanking delay and active lines */
>  	cx18_av_write(cx, 0x470, hblank);
> -	cx18_av_write(cx, 0x471, 0xff & (((hblank >> 8) & 0x3) |
> -						(hactive << 4)));
> +	cx18_av_write(cx, 0x471,
> +		      (((hblank >> 8) & 0x3) | (hactive << 4)) & 0xff);
>  	cx18_av_write(cx, 0x472, hactive >> 4);
>  
>  	/* Sets burst gate delay */
> @@ -499,14 +499,14 @@ void cx18_av_std_setup(struct cx18 *cx)
>  
>  	/* Sets vertical blanking delay and active duration */
>  	cx18_av_write(cx, 0x474, vblank);
> -	cx18_av_write(cx, 0x475, 0xff & (((vblank >> 8) & 0x3) |
> -						(vactive << 4)));
> +	cx18_av_write(cx, 0x475,
> +		      (((vblank >> 8) & 0x3) | (vactive << 4)) & 0xff);
>  	cx18_av_write(cx, 0x476, vactive >> 4);
>  	cx18_av_write(cx, 0x477, vblank656);
>  
>  	/* Sets src decimation rate */
> -	cx18_av_write(cx, 0x478, 0xff & src_decimation);
> -	cx18_av_write(cx, 0x479, 0xff & (src_decimation >> 8));
> +	cx18_av_write(cx, 0x478, src_decimation & 0xff);
> +	cx18_av_write(cx, 0x479, (src_decimation >> 8) & 0xff);
>  
>  	/* Sets Luma and UV Low pass filters */
>  	cx18_av_write(cx, 0x47a, luma_lpf << 6 | ((uv_lpf << 4) & 0x30));
> @@ -516,8 +516,8 @@ void cx18_av_std_setup(struct cx18 *cx)
>  
>  	/* Sets SC Step*/
>  	cx18_av_write(cx, 0x47c, sc);
> -	cx18_av_write(cx, 0x47d, 0xff & sc >> 8);
> -	cx18_av_write(cx, 0x47e, 0xff & sc >> 16);
> +	cx18_av_write(cx, 0x47d, (sc >> 8) & 0xff);
> +	cx18_av_write(cx, 0x47e, (sc >> 16) & 0xff);
>  
>  	if (std & V4L2_STD_625_50) {
>  		state->slicer_line_delay = 1;


