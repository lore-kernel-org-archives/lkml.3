Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbaJCXqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:46:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268AbaJCWDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hante Meuleman <meuleman@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.16 282/357] brcmfmac: handle IF event for P2P_DEVICE interface
Date: Fri,  3 Oct 2014 14:31:08 -0700
Message-Id: <20141003212941.961451990@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arend van Spriel <arend@broadcom.com>

commit 87c4790330810fe5caf0172d9320cf24ef19cebe upstream.

The firmware notifies about interface changes through the IF event
which has a NO_IF flag that means host can ignore the event. This
behaviour was introduced in the driver by:

  commit 2ee8382fc6c763c76396a6aaff77a27089eed3aa
  Author: Arend van Spriel <arend@broadcom.com>
  Date:   Sat Aug 10 12:27:24 2013 +0200

      brcmfmac: ignore IF event if firmware indicates it

It turns out that the IF event for the P2P_DEVICE also has this
flag set, but the event should not be ignored in this scenario.
The mentioned commit caused a regression in 3.12 kernel in creation
of the P2P_DEVICE interface.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c |   12 +++++++++---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h |    2 ++
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -185,7 +185,13 @@ static void brcmf_fweh_handle_if_event(s
 		  ifevent->action, ifevent->ifidx, ifevent->bssidx,
 		  ifevent->flags, ifevent->role);
 
-	if (ifevent->flags & BRCMF_E_IF_FLAG_NOIF) {
+	/* The P2P Device interface event must not be ignored
+	 * contrary to what firmware tells us. The only way to
+	 * distinguish the P2P Device is by looking at the ifidx
+	 * and bssidx received.
+	 */
+	if (!(ifevent->ifidx == 0 && ifevent->bssidx == 1) &&
+	    (ifevent->flags & BRCMF_E_IF_FLAG_NOIF)) {
 		brcmf_dbg(EVENT, "event can be ignored\n");
 		return;
 	}
@@ -210,12 +216,12 @@ static void brcmf_fweh_handle_if_event(s
 				return;
 	}
 
-	if (ifevent->action == BRCMF_E_IF_CHANGE)
+	if (ifp && ifevent->action == BRCMF_E_IF_CHANGE)
 		brcmf_fws_reset_interface(ifp);
 
 	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
 
-	if (ifevent->action == BRCMF_E_IF_DEL) {
+	if (ifp && ifevent->action == BRCMF_E_IF_DEL) {
 		brcmf_fws_del_interface(ifp);
 		brcmf_del_if(drvr, ifevent->bssidx);
 	}
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -167,6 +167,8 @@ enum brcmf_fweh_event_code {
 #define BRCMF_E_IF_ROLE_STA			0
 #define BRCMF_E_IF_ROLE_AP			1
 #define BRCMF_E_IF_ROLE_WDS			2
+#define BRCMF_E_IF_ROLE_P2P_GO			3
+#define BRCMF_E_IF_ROLE_P2P_CLIENT		4
 
 /**
  * definitions for event packet validation.


