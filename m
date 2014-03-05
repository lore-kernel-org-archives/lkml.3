Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbaCEQ7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:59:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270AbaCEQ7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:59:07 -0500
From: Steve Grubb <sgrubb@redhat.com>
To: linux-audit@redhat.com
Cc: David Miller <davem@davemloft.net>, ebiederm@xmission.com, rgb@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] audit: Simplify by assuming the callers socket buffer is large enough
Date: Wed, 05 Mar 2014 11:59:01 -0500
Message-ID: <7457128.6VP2v68V93@x2>
Organization: Red Hat
User-Agent: KMail/4.12.2 (Linux/3.13.5-200.fc20.x86_64; KDE/4.12.2; x86_64; ; )
In-Reply-To: <20140304.192152.1234652192226780071.davem@davemloft.net>
References: <20140304133004.b565820f60f595a48e621e58@linux-foundation.org> <87mwh5d1tf.fsf@xmission.com> <20140304.192152.1234652192226780071.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 04, 2014 07:21:52 PM David Miller wrote:
> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Tue, 04 Mar 2014 14:41:16 -0800
> 
> > If we really want the ability to always appened to the queue of skb's
> > is to just have a version of netlink_send_skb that ignores the queued
> > limits.  Of course an evil program then could force the generation of
> > enough audit records to DOS the kernel, but we seem to be in that
> > situation now.  Shrug.
> 
> There is never a valid reason to bypass the socket limits.
> 
> It protects the system from things going out of control.
> 
> Netlink packet sends can fail, and audit should cope with that
> event instead of trying to bludgeon it into not happening.

I am not sure what exactly is the problem with the code that was being 
patched. The audit code has been stable and working pretty well for everyone 
for the last 5-6 years. But lately there has been a lot of kernel code churn 
and I am concerned that the changes are being made without a complete 
understanding of the design goals.

The audit system has to be very reliable. It can't lose any event or record. 
The people that really depend on it would rather have access denied to the 
system than lose any event. This is the reason it goes to such lengths.

If I understand the patch, it looks like its affecting code that adds, deletes, 
or lists audit rules. This code is quite old and working well. It didn't at 
first. We found a lot of problems by writing scripts like:

#!/bin/bash
while [ 1 ] ;
do
        echo "Inserting syscalls..."
        sys=1
        while [ $sys -lt 100 ]
        do
                sys=`expr $sys + 1`
                echo "$sys"
                auditctl -a entry,always -S $sys
        done

        echo "Listing..."
        auditctl -l
        echo "Deleting..."
        auditctl -D
done

with another shell running:

#!/bin/bash
while [ 1 ] ; 
do
	echo "Listing..."
	auditctl -l
done

and another shell running:

#!/bin/bash
while [ 1 ] ; 
do
	echo "Disabling..."
	auditctl -e 0
	echo "Enabling..."
	auditctl -e 1
done

You can probably imagine more stress tests. But the proposed code should be 
well tested similar to this.

Thanks,
-Steve
