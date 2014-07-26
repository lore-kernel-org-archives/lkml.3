Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaGZTdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:33:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaGZTVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:21:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Schulz <develop@kristov.de>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 071/109] net: ppp: dont call sk_chk_filter twice
Date: Sat, 26 Jul 2014 12:02:33 -0700
Message-Id: <20140726190226.014888929@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Schulz <develop@kristov.de>

[ Upstream commit 3916a3192793fd3c11f69d623ef0cdbdbf9ea10a ]

Commit 568f194e8bd16c353ad50f9ab95d98b20578a39d ("net: ppp: use
sk_unattached_filter api") causes sk_chk_filter() to be called twice when
setting a PPP pass or active filter. This applies to both the generic PPP
subsystem implemented by drivers/net/ppp/ppp_generic.c and the ISDN PPP
subsystem implemented by drivers/isdn/i4l/isdn_ppp.c. The first call is from
within get_filter(). The second one is through the call chain

  ppp_ioctl() or isdn_ppp_ioctl()
  --> sk_unattached_filter_create()
      --> __sk_prepare_filter()
          --> sk_chk_filter()

The first call from within get_filter() should be deleted as get_filter() is
called just before calling sk_unattached_filter_create() later on, which
eventually calls sk_chk_filter() anyway.

For 3.15.x, this proposed change is a bugfix rather than a pure optimization as
in that branch, sk_chk_filter() may replace filter codes by other codes which
are not recognized when executing sk_chk_filter() a second time. So with
3.15.x, if sk_chk_filter() is called twice, the second invocation may yield
EINVAL (this depends on the filter codes found in the filter to be set, but
because the replacement is done for frequently used codes, this is almost
always the case). The net effect is that setting pass and/or active PPP filters
does not work anymore, since sk_unattached_filter_create() always returns
EINVAL due to the second call to sk_chk_filter(), regardless whether the filter
was originally sane or not.

Signed-off-by: Christoph Schulz <develop@kristov.de>
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/i4l/isdn_ppp.c   |    8 +-------
 drivers/net/ppp/ppp_generic.c |    8 +-------
 2 files changed, 2 insertions(+), 14 deletions(-)

--- a/drivers/isdn/i4l/isdn_ppp.c
+++ b/drivers/isdn/i4l/isdn_ppp.c
@@ -442,7 +442,7 @@ static int get_filter(void __user *arg,
 {
 	struct sock_fprog uprog;
 	struct sock_filter *code = NULL;
-	int len, err;
+	int len;
 
 	if (copy_from_user(&uprog, arg, sizeof(uprog)))
 		return -EFAULT;
@@ -458,12 +458,6 @@ static int get_filter(void __user *arg,
 	if (IS_ERR(code))
 		return PTR_ERR(code);
 
-	err = sk_chk_filter(code, uprog.len);
-	if (err) {
-		kfree(code);
-		return err;
-	}
-
 	*p = code;
 	return uprog.len;
 }
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -539,7 +539,7 @@ static int get_filter(void __user *arg,
 {
 	struct sock_fprog uprog;
 	struct sock_filter *code = NULL;
-	int len, err;
+	int len;
 
 	if (copy_from_user(&uprog, arg, sizeof(uprog)))
 		return -EFAULT;
@@ -554,12 +554,6 @@ static int get_filter(void __user *arg,
 	if (IS_ERR(code))
 		return PTR_ERR(code);
 
-	err = sk_chk_filter(code, uprog.len);
-	if (err) {
-		kfree(code);
-		return err;
-	}
-
 	*p = code;
 	return uprog.len;
 }


