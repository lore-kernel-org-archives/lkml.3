Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761723Ab3JPSft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:35:49 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64967 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761258Ab3JPSfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:35:47 -0400
Date: Wed, 16 Oct 2013 11:35:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: rydberg@euromail.se, Kamal Mostafa <kamal@canonical.com>,
        linux-kernel@vger.kernel.org, dudl@cypress.com, git@status.e4ward.com,
        tim.gardner@canonical.com, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1][Resend] Input: cypress_ps2 - Return zero finger
 count if palm is detected.
Message-ID: <20131016183543.GA21932@core.coreip.homeip.net>
References: <cover.1379968154.git.joseph.salisbury@canonical.com>
 <007c09ae4ef7f72ffb657de0fb3854fcbc6d88f0.1379968154.git.joseph.salisbury@canonical.com>
 <1380571922.15513.29.camel@fourier>
 <525827B3.9080003@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525827B3.9080003@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Fri, Oct 11, 2013 at 12:30:43PM -0400, Joseph Salisbury wrote:
> On 09/30/2013 04:12 PM, Kamal Mostafa wrote:
> > On Tue, 2013-09-24 at 11:44 -0400, Joseph Salisbury wrote:
> >> BugLink: http://bugs.launchpad.net/bugs/1229361
> >>
> >> This patch sets the finger count to 0 in the case of palm contact.
> >>
> >> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
> >> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com> (maintainer:INPUT (KEYBOARD,...,commit_signer:2/2=100%)
> >> Cc: Henrik Rydberg <rydberg@euromail.se> (maintainer:INPUT MULTITOUCH...)
> >> Cc: Kamal Mostafa <kamal@canonical.com> (commit_signer:2/2=100%)
> >> Cc: Dudley Du <dudl@cypress.com> (commit_signer:2/2=100%)
> >> Cc: Kyle Fazzari <git@status.e4ward.com> (commit_signer:1/2=50%)
> >> Cc: Tim Gardner <tim.gardner@canonical.com> (commit_signer:1/2=50%)
> >> Cc: linux-input@vger.kernel.org (open list:INPUT (KEYBOARD,...)
> >> Cc: linux-kernel@vger.kernel.org (open list)
> >> Cc: stable@vger.kernel.org
> > This patch works fine: eliminates stream of junk driver messages with no
> > ill effects.
> >
> > Tested-by: Kamal Mostafa <kamal@canonical.com>
> >
> >  -Kamal
> >
> >
> >> ---
> >>  drivers/input/mouse/cypress_ps2.c |    4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
> >> index 45b3eda..95b2c40 100644
> >> --- a/drivers/input/mouse/cypress_ps2.c
> >> +++ b/drivers/input/mouse/cypress_ps2.c
> >> @@ -441,7 +441,7 @@ static int cypress_get_finger_count(unsigned char header_byte)
> >>  			case 2: return 5;
> >>  			default:
> >>  				/* Invalid contact (e.g. palm). Ignore it. */
> >> -				return -1;
> >> +				return 0;
> >>  		}
> >>  	}
> >>  
> >> @@ -460,7 +460,7 @@ static int cypress_parse_packet(struct psmouse *psmouse,
> >>  
> >>  	contact_cnt = cypress_get_finger_count(header_byte);
> >>  
> >> -	if (contact_cnt < 0) /* e.g. palm detect */
> >> +	if (contact_cnt < 0)
> >>  		return -EINVAL;
> >>  
> >>  	report_data->contact_cnt = contact_cnt;
> Hi Dmitry and Henrik,
> 
> Have you had a chance to review this patch to consider it for inclusion
> in mainline?

I think the main problem is that we were reporting PSMOUSE_BAD_DATA for
palm packets.

Could you try a slightly extended patch below to make sure it all still
works?

Thanks!

-- 
Dmitry

Input: cypress_ps2 - do not consider data bad if palm is detected

From: Joseph Salisbury <joseph.salisbury@canonical.com>

If hardware (or firmware) detects palm on the surface of the device it does
not mean that the data packet is bad from the protocol standpoint. Instead
of reporting PSMOUSE_BAD_DATA in this case simply threat it as if nothing
touches the surface.

BugLink: http://bugs.launchpad.net/bugs/1229361

Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Tested-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/mouse/cypress_ps2.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
index ef651cc..e499e55 100644
--- a/drivers/input/mouse/cypress_ps2.c
+++ b/drivers/input/mouse/cypress_ps2.c
@@ -439,7 +439,7 @@ static int cypress_get_finger_count(unsigned char header_byte)
 			case 2: return 5;
 			default:
 				/* Invalid contact (e.g. palm). Ignore it. */
-				return -1;
+				return 0;
 		}
 	}
 
@@ -452,17 +452,10 @@ static int cypress_parse_packet(struct psmouse *psmouse,
 {
 	unsigned char *packet = psmouse->packet;
 	unsigned char header_byte = packet[0];
-	int contact_cnt;
 
 	memset(report_data, 0, sizeof(struct cytp_report_data));
 
-	contact_cnt = cypress_get_finger_count(header_byte);
-
-	if (contact_cnt < 0) /* e.g. palm detect */
-		return -EINVAL;
-
-	report_data->contact_cnt = contact_cnt;
-
+	report_data->contact_cnt = cypress_get_finger_count(header_byte);
 	report_data->tap = (header_byte & ABS_MULTIFINGER_TAP) ? 1 : 0;
 
 	if (report_data->contact_cnt == 1) {
@@ -535,11 +528,9 @@ static void cypress_process_packet(struct psmouse *psmouse, bool zero_pkt)
 	int slots[CYTP_MAX_MT_SLOTS];
 	int n;
 
-	if (cypress_parse_packet(psmouse, cytp, &report_data))
-		return;
+	cypress_parse_packet(psmouse, cytp, &report_data);
 
 	n = report_data.contact_cnt;
-
 	if (n > CYTP_MAX_MT_SLOTS)
 		n = CYTP_MAX_MT_SLOTS;
 
@@ -604,11 +595,6 @@ static psmouse_ret_t cypress_validate_byte(struct psmouse *psmouse)
 	if ((packet[0] & 0x08) == 0x08)
 		return PSMOUSE_BAD_DATA;
 
-	contact_cnt = cypress_get_finger_count(packet[0]);
-
-	if (contact_cnt < 0)
-		return PSMOUSE_BAD_DATA;
-
 	if (cytp->mode & CYTP_BIT_ABS_NO_PRESSURE)
 		cypress_set_packet_size(psmouse, contact_cnt == 2 ? 7 : 4);
 	else
