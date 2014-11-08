Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaKHUwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 15:52:53 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54785 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbaKHUwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 15:52:51 -0500
Date: Sat, 8 Nov 2014 12:52:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] input: alps: Do not try to parse data as 3 bytes
 packet when driver is out of sync
Message-ID: <20141108205247.GB40319@dtor-ws>
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com>
 <1414884310-19842-1-git-send-email-pali.rohar@gmail.com>
 <1414884310-19842-2-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414884310-19842-2-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 12:25:07AM +0100, Pali Rohár wrote:
> 5th and 6th byte of ALPS trackstick V3 protocol match condition for first byte
> of PS/2 3 bytes packet. When driver enters out of sync state and ALPS trackstick
> is sending data then driver match 5th, 6th and next 1st bytes as PS/2.
> 
> It basically means if user is using trackstick when driver is in out of sync
> state driver will never resync. Processing these bytes as 3 bytes PS/2 data
> cause total mess (random cursor movements, random clicks) and make trackstick
> unusable until psmouse driver decide to do full device reset.
> 
> Lot of users reported problems with ALPS devices on Dell Latitude E6440, E6540
> and E7440 laptops. ALPS device or Dell EC for unknown reason send some invalid
> ALPS PS/2 bytes which cause driver out of sync. It looks like that i8042 and
> psmouse/alps driver always receive group of 6 bytes packets so there are no
> missing bytes and no bytes were inserted between valid once.
> 
> This patch does not fix root of problem with ALPS devices found in Dell Latitude
> laptops but it does not allow to process some (invalid) subsequence of 6 bytes
> ALPS packets as 3 bytes PS/2 when driver is out of sync.
> 
> So with this patch trackstick input device does not report bogus data when
> also driver is out of sync, so trackstick should be usable on those machines.
> 
> Unknown is also information which ALPS devices send 3 bytes packets and why
> ALPS driver needs to handle also bare PS/2 packets. According to git (and plus
> historic tree from bitkeeper) code for processing 3 bytes bare PS/2 packets
> is there since first version of alps.c existence (since 2.6.9-rc2).

I believe it was to handle external devices plugged into PS/2 ports on
Dell laptops (maybe?). Dell laptops do not use active multiplexing
controller so everything comes mixed into single data stream.

> 
> We do not want to break some older ALPS devices. And disabling processing bare
> PS/2 packets when driver is out of sync should not break it.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Tested-by: Pali Rohár <pali.rohar@gmail.com>
> Cc: stable@vger.kernel.org

Applied, thank you.

> ---
>  drivers/input/mouse/alps.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
> index 2b0ae8c..a772745 100644
> --- a/drivers/input/mouse/alps.c
> +++ b/drivers/input/mouse/alps.c
> @@ -1156,7 +1156,9 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
>  {
>  	struct alps_data *priv = psmouse->private;
>  
> -	if ((psmouse->packet[0] & 0xc8) == 0x08) { /* PS/2 packet */
> +	/* FIXME: Could we receive bare PS/2 packets from DualPoint devices?? */
> +	if (!psmouse->out_of_sync_cnt &&
> +	    (psmouse->packet[0] & 0xc8) == 0x08) { /* PS/2 packet */
>  		if (psmouse->pktcnt == 3) {
>  			alps_report_bare_ps2_packet(psmouse, psmouse->packet,
>  						    true);
> -- 
> 1.7.9.5
> 

-- 
Dmitry
