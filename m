Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab3FLSzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:55:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019Ab3FLSzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:55:24 -0400
Message-ID: <51B8C457.5050502@redhat.com>
Date: Wed, 12 Jun 2013 11:56:23 -0700
From: Anand Avati <avati@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Brian Foster <bfoster@redhat.com>
CC: Maxim Patlasov <MPatlasov@parallels.com>, miklos@szeredi.hu,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Subject: Re: [PATCH] fuse: hold i_mutex in fuse_file_fallocate()
References: <20130611105714.24455.38409.stgit@maximpc.sw.ru> <51B85E26.8000303@redhat.com>
In-Reply-To: <51B85E26.8000303@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/13 4:40 AM, Brian Foster wrote:
> On 06/11/2013 06:59 AM, Maxim Patlasov wrote:
>> Changing size of a file on server and local update (fuse_write_update_size)
>> should be always protected by inode->i_mutex. Otherwise a race like this is
>> possible:
>>
>> 1. Process 'A' calls fallocate(2) to extend file (~FALLOC_FL_KEEP_SIZE).
>> fuse_file_fallocate() sends FUSE_FALLOCATE request to the server.
>> 2. Process 'B' performs ordinary buffered write(2) with a length big enough
>> to extend the file beyond "offset + length" of fallocate call.
>> 3. Process 'A' resumes execution of fuse_file_fallocate() and calls
>> fuse_write_update_size(inode, offset + length). But 'offset + length' was
>> obsoleted by write from previous step.
>>
>
> Hi Maxim,
>
> Doesn't fuse_write_update_size() already handle this particular case by
> only ever extending the size?
>


As you say, fuse_write_update_size() does seem to protect against the 
case Maxim writes in the commit log.

However, there is still an issue with with truncate(shrinking_offset) 
and fallocate(growing_offset,~FALLOC_FL_KEEP_SIZE) racing, and changing 
inode size in opposing order between file server and in core ->i_size. 
Therefore, grabbing i_mutex is making fallocate and truncate atomic 
against each other.

I guess we just need an updated commit log, and same code change?

Avati


