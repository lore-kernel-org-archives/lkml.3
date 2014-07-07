Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaGHARr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:17:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbaGGXzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:55:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.10 39/53] iio: of_iio_channel_get_by_name() returns non-null pointers for error legs
Date: Mon,  7 Jul 2014 16:58:24 -0700
Message-Id: <20140707235830.467711676@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235829.281783607@linuxfoundation.org>
References: <20140707235829.281783607@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>

commit a2c12493ed7e63a18cef33a71686d12ffcd6600e upstream.

Currently in the inkern.c code for IIO framework, the function
of_iio_channel_get_by_name() will return a non-NULL pointer when
it cannot find a channel using of_iio_channel_get() and when it
tries to search for 'io-channel-ranges' property and fails. This
is incorrect behaviour as the function which calls this expects
a NULL pointer for failure. This patch rectifies the issue.

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/inkern.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -183,7 +183,7 @@ static struct iio_channel *of_iio_channe
 		else if (name && index >= 0) {
 			pr_err("ERROR: could not get IIO channel %s:%s(%i)\n",
 				np->full_name, name ? name : "", index);
-			return chan;
+			return NULL;
 		}
 
 		/*
@@ -193,8 +193,9 @@ static struct iio_channel *of_iio_channe
 		 */
 		np = np->parent;
 		if (np && !of_get_property(np, "io-channel-ranges", NULL))
-			break;
+			return NULL;
 	}
+
 	return chan;
 }
 
@@ -317,6 +318,7 @@ struct iio_channel *iio_channel_get(stru
 		if (channel != NULL)
 			return channel;
 	}
+
 	return iio_channel_get_sys(name, channel_name);
 }
 EXPORT_SYMBOL_GPL(iio_channel_get);


