Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3LSEXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 23:23:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:11512 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab3LSEXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 23:23:41 -0500
X-IronPort-AV: E=Sophos;i="4.95,511,1384272000"; 
   d="scan'208";a="9288556"
Message-ID: <52B26F1A.9070308@cn.fujitsu.com>
Date: Thu, 19 Dec 2013 11:59:22 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>
CC: linux-audit@redhat.com, Eric Paris <eparis@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] audit: listen in all network namespaces
References: <1374006760-7687-1-git-send-email-rgb@redhat.com>
In-Reply-To: <1374006760-7687-1-git-send-email-rgb@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 11:57:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 11:57:55,
	Serialize complete at 2013/12/19 11:57:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 04:32 AM, Richard Guy Briggs wrote:
> Convert audit from only listening in init_net to use register_pernet_subsys()
> to dynamically manage the netlink socket list.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---

I think it's the time for us to discuss if we should revert this
commit, since this one prevent me from continuing to achieve
audit namespace.


The major problem is in kaudit_send_skb, we have no idea which
audit sock the skb should send to.

in this patch, there only is one auditd proecess, so the
audit_sock is the only one. but when we have audit namespace.
there will be multi audit socks. we have to store audit_sock
into auditns(auditns will be passed to kauditd_send_skb),
this will cause auditns have to get a reference of netns.
and for some reason(netfilter audit target), netns will
get reference of auditns too. this is terrible...

So why not we revert this one, and use a very simple one to
replace it? the below patch will save us from the refer to
each other case, achieve the same effect.

what's your opinion?


Add a compare function which always return true for
audit netlink socket, this will cause audit netlink
sockets netns unaware, and no matter which netns the
user space audit netlink sockets belong to, they all
can find out and communicate with audit_sock.

This gets rid of the necessary to create per-netns
audit kernel side socket(audit_sock), it's pain to
depend on and get reference of netns for auditns.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 7b0e23a..468950b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -886,12 +886,18 @@ static void audit_receive(struct sk_buff  *skb)
 	mutex_unlock(&audit_cmd_mutex);
 }

+static bool audit_compare(struct net *net, struct sock *sk)
+{
+	return true;
+}
+
 /* Initialize audit support at boot time. */
 static int __init audit_init(void)
 {
 	int i;
 	struct netlink_kernel_cfg cfg = {
 		.input	= audit_receive,
+		.compare = audit_compare,
 	};

 	if (audit_initialized == AUDIT_DISABLED)
