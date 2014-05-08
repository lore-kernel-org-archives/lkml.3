Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaEHGkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 02:40:55 -0400
Received: from smtprelay0119.hostedemail.com ([216.40.44.119]:36611 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753071AbaEHGky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 02:40:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2898:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3874:4321:5007:6119:7652:7904:9010:9040:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12679:12740:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: oil68_24a05bfcb1115
X-Filterd-Recvd-Size: 3008
Message-ID: <1399531250.4146.12.camel@joe-AO725>
Subject: Re: [PATCH] Staging: gdm72xx Fix minor coding style problems
From: Joe Perches <joe@perches.com>
To: Adithya K <linux.challenge1@gmail.com>
Cc: standby24x7@gmail.com, dan.carpenter@oracle.com, khoroshilov@ispras.ru,
        arnd@arndb.de, burzalodowa@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Date: Wed, 07 May 2014 23:40:50 -0700
In-Reply-To: <1399530237-1788-1-git-send-email-user@akrishna-Latitude-E6430>
References: <n>
	 <1399530237-1788-1-git-send-email-user@akrishna-Latitude-E6430>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-08 at 11:53 +0530, Adithya K wrote:
> This is patch for fixing of minor coding style problems.
[]
> diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
[]
> @@ -229,6 +229,7 @@ static u32 extract_qos_list(struct nic *nic, struct list_head *head)
>  					entry = list_entry(
>  					qcb->qos_list[i].prev,
>  					struct qos_entry_s, list);
> +
>  					list_move_tail(&entry->list, head);

That one is a checkpatch defect.

The list_entry( use is really ugly too
with bad indentation on the following line.

Look at the entire function:

static u32 extract_qos_list(struct nic *nic, struct list_head *head)
{
	struct qos_cb_s *qcb = &nic->qos;
	struct qos_entry_s *entry;
	int i;

	INIT_LIST_HEAD(head);

	for (i = 0; i < QOS_MAX; i++) {
		if (qcb->csr[i].enabled) {
			if (qcb->csr[i].qos_buf_count < qcb->qos_limit_size) {
				if (!list_empty(&qcb->qos_list[i])) {
					entry = list_entry(
					qcb->qos_list[i].prev,
					struct qos_entry_s, list);
					list_move_tail(&entry->list, head);
					qcb->csr[i].qos_buf_count++;

					if (!list_empty(&qcb->qos_list[i]))
						netdev_warn(nic->netdev,
							    "Index(%d) is piled!!\n",
							    i);
				}
			}
		}
	}

	return 0;
}

Please consider rewriting the function
to reduce unnecessary indentation.

Something like:

static u32 extract_qos_list(struct nic *nic, struct list_head *head)
{
	struct qos_cb_s *qcb = &nic->qos;
	int i;

	INIT_LIST_HEAD(head);

	for (i = 0; i < QOS_MAX; i++) {
		if (!qcb->csr[i].enabled ||
		    qcb->csr[i].qos_buf_count >= qcb->qos_limit_size)
			continue;

		if (!list_empty(&qcb->qos_list[i])) {
			struct qos_entry_s *entry;

			entry = list_entry(qcb->qos_list[i].prev,
					   struct qos_entry_s, list);
			list_move_tail(&entry->list, head);
			qcb->csr[i].qos_buf_count++;

			if (!list_empty(&qcb->qos_list[i]))
				netdev_warn(nic->netdev, "Index(%d) is piled!!\n",
					    i);
		}
	}

	return 0;
}


