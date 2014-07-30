Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaG3BuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:50:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbaG3BuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:50:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew de los Reyes <adlr@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.15 20/37] Input: fix defuzzing logic
Date: Tue, 29 Jul 2014 18:48:56 -0700
Message-Id: <20140730014828.682165307@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
References: <20140730014827.565626091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dtor@chromium.org>

commit 50c5d36dab930b1f1b1e3348b8608aa8b9ee7610 upstream.

We attempt to remove noise from coordinates reported by devices in
input_handle_abs_event(), unfortunately, unless we were dropping the
event altogether, we were ignoring the adjusted value and were passing
on the original value instead.

Reviewed-by: Andrew de los Reyes <adlr@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Reviewed-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/input.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -257,9 +257,10 @@ static int input_handle_abs_event(struct
 }
 
 static int input_get_disposition(struct input_dev *dev,
-			  unsigned int type, unsigned int code, int value)
+			  unsigned int type, unsigned int code, int *pval)
 {
 	int disposition = INPUT_IGNORE_EVENT;
+	int value = *pval;
 
 	switch (type) {
 
@@ -357,6 +358,7 @@ static int input_get_disposition(struct
 		break;
 	}
 
+	*pval = value;
 	return disposition;
 }
 
@@ -365,7 +367,7 @@ static void input_handle_event(struct in
 {
 	int disposition;
 
-	disposition = input_get_disposition(dev, type, code, value);
+	disposition = input_get_disposition(dev, type, code, &value);
 
 	if ((disposition & INPUT_PASS_TO_DEVICE) && dev->event)
 		dev->event(dev, type, code, value);


