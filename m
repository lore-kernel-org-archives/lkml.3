Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935972Ab3DJViV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:38:21 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:36257 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab3DJViU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:38:20 -0400
Date: Wed, 10 Apr 2013 17:38:17 -0400 (EDT)
From: Eric Paris <eparis@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <1145090153.12320456.1365629897666.JavaMail.root@redhat.com>
In-Reply-To: <516540CB.7090301@asianux.com>
References: <51653645.90401@asianux.com> <51653C7A.6030405@asianux.com> <51653EC2.5030107@asianux.com> <516540CB.7090301@asianux.com>
Subject: Re: [PATCH] kernel: auditfilter: looping issue, memory leak if has
 2 or more AUDIT_FILTERKEYs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: kernel: auditfilter: looping issue, memory leak if has 2 or more AUDIT_FILTERKEYs
Thread-Index: kQ9sK6n98wwSOJm36qr5WHCPOaci/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> 
>   also for function audit_list_rules:
>     when call audit_make_reply fails (will return NULL).
>     we also need process data->buf, not only data itself.
> 
>   please help check, thanks.

struct audit_rule_data {
[...]
        char            buf[0]; /* string fields buffer */
};

The last element in the struct is 0 length.  But the allocation in audit_krule_to_data() looks like:

data = kmalloc(sizeof(*data) + krule->buflen, GFP_KERNEL);

So now data->buf appears as an allocation of size krule->buflen.

We do not need to free it separately.  This is a pretty common C trick.

-Eric
