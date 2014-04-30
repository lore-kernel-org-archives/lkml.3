Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaD3DWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 23:22:12 -0400
Received: from linuxhacker.ru ([217.76.32.60]:43793 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaD3DWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 23:22:10 -0400
Subject: Re: [PATCH 41/47] staging/lustre/llite: remove dead code
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140429110251.GC26890@mwanda>
Date: Tue, 29 Apr 2014 23:21:48 -0400
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "John L. Hammond" <john.hammond@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <DAD2A56A-3ABC-49C6-BA21-95CD95BF805F@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru> <1398618431-29757-42-git-send-email-green@linuxhacker.ru> <20140429110251.GC26890@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Apr 29, 2014, at 7:02 AM, Dan Carpenter wrote:

>> diff --git a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
>> index 51c5327..1b47774 100644
>> --- a/drivers/staging/lustre/lustre/llite/statahead.c
>> +++ b/drivers/staging/lustre/lustre/llite/statahead.c
>> @@ -1230,9 +1230,7 @@ do_it:
>> 			 */
>> 			ll_release_page(page, le32_to_cpu(dp->ldp_flags) &
>> 					      LDF_COLLIDE);
>> -			sai->sai_in_readpage = 1;
>> 			page = ll_get_dir_page(dir, pos, &chain);
>> -			sai->sai_in_readpage = 0;
>> 		} else {
>> 			LASSERT(le32_to_cpu(dp->ldp_flags) & LDF_COLLIDE);
>> 			ll_release_page(page, 1);
>> @@ -1563,12 +1561,6 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
>> 			return entry ? 1 : -EAGAIN;
>> 		}
>> 
>> -		/* if statahead is busy in readdir, help it do post-work */
>> -		while (!ll_sa_entry_stated(entry) &&
>> -		       sai->sai_in_readpage &&
>> -		       !sa_received_empty(sai))
>> -			ll_post_statahead(sai);
>> -
>> 		if (!ll_sa_entry_stated(entry)) {
>> 			sai->sai_index_wait = entry->se_index;
>> 			lwi = LWI_TIMEOUT_INTR(cfs_time_seconds(30), NULL,
> 
> What is this change about really?  I've already waded through 1271 lines
> of random changes at this point and now I have to figure out what
> ll_post_statahead() does and why we don't need to call it now?
> 
> Anyways, please explain this change.

Ok, so after some digging.
The first hunk of the above was gone in our code with the move of a lot of directory
processing down onto mdc layer as part of support for multiple metadata servers (a new feature).
Then the second hunk was the cleanup sine nobody was setting the sai_in_readpage ever.

sai_in_readpage in itself originally was devised as performance optimization for the case where the
statahead thread is waiting for READDIR RPC to return while there are already some GETATTR RPCs
that have already returned and are waiting to be interpreted.
This does not affect correctness in any way, though. And removing it brings the code closer to
our current tree which is hopefully a good thing.
I can rediff this patch with this particular part dropped if there are any concerns and it's possible
to reintegrate it in a changed form.

Bye,
    Oleg