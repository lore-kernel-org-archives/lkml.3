Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3A3DWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:22:38 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46066 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3A3DWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:22:36 -0500
Message-ID: <510891ED.8090404@oracle.com>
Date: Tue, 29 Jan 2013 21:22:21 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH V6 00/30] loop: Issue O_DIRECT aio using bio_vec
References: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com> <x49obg7omos.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49obg7omos.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 12:42 PM, Jeff Moyer wrote:
> Dave Kleikamp <dave.kleikamp@oracle.com> writes:
> 
>> Al,
>> I'd like to push this patchset to linux-next. Would you like to pull it
>> into your vfs tree, would you rather I submitted it separately, or do
>> you have any issues with it before including it?
> 
> I'm still chasing one regression in this patchset.  If you use the ext4
> driver for ext2 file systems, and you run the libaio test harness, then
> you will be able to successfully write beyond the maximum file size in a
> file (see test case 8).

I found the problem. iov_iter_shorten() wasn't setting i->count to the new
value.

This fixes it. I'll fix the patchset tomorrow.

Thanks,
Shaggy

diff --git a/fs/iov-iter.c b/fs/iov-iter.c
index ac2d96e..ade8c11 100644
--- a/fs/iov-iter.c
+++ b/fs/iov-iter.c
@@ -370,6 +370,7 @@ static int ii_iovec_shorten(struct iov_iter *i, size_t count)
 {
 	struct iovec *iov = (struct iovec *)i->data;
 	i->nr_segs = iov_shorten(iov, i->nr_segs, count);
+	i->count = min(i->count, count);
 	return 0;
 }
 
