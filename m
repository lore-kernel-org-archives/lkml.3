Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbaHMDNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 23:13:22 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55972 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaHMDNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 23:13:20 -0400
X-AuditID: 85900ec0-d312bb9000001514-41-53ead7cc3a45
Message-ID: <53EAD7CC.8030408@hitachi.com>
Date: Wed, 13 Aug 2014 12:13:16 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: dgilbert@interlog.com
Cc: Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: Re: [RFC PATCH -logging 00/10] scsi/constants: Output continuous
 error messages on trace
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <53E4CB7B.7020705@interlog.com>
In-Reply-To: <53E4CB7B.7020705@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Douglas,

Thank you for your comment.

(2014/08/08 22:07), Douglas Gilbert wrote:
> On 14-08-08 01:50 PM, Yoshihiro YUNOMAE wrote:
>> Hi All,
>>
>> This patch set introduces new traceevents in order to output
>> continuous error
>> messages. Current SCSI printk messages in upstream kernel can be
>> divided by and
>> mixed with other messages. Even if each error message has its device id,
>> sometimes we can easily be lost in mixed logs because the message's
>> device id
>> is separated from it's body. To avoid it, I'd like to use traceevents to
>> store error messages into the ftrace or perf buuffer, because traceevents
>> are atomically commited to the buffer.
>>
>> In this patch set, all printk messages are removed based on a local
>> discussion with Hannes, but I think printk messages should be kept
>> because all
>> users don't enable traceevents and rsyslog can store as files.
>>
>> However, if printk of logging branch is kept, the messages are
>> duplicate and
>> it can induce stack overflow by using local buffer(*1).
>>
>>   (*1) https://lkml.org/lkml/2014/5/20/742
>>
>> So, my suggestion is follows:
>>
>> 1) printk
>> Keeps current implemntation of upstream kernel.
>> The messages are divided and can be mixed, but all users can check the
>> error
>> messages without any settings.
>>
>> 2) traceevents
>> To get the complete messages, we can use ftrace or perf (or something
>> on them).
>> Users can always understand correct messages, but they need to set up the
>> tracers.
>>
>> This patch set is based on Hannes' logging branch:
>> http://git.kernel.org/cgit/linux/kernel/git/hare/scsi-devel.git/log/?h=logging
>>
>>
>> [1/10] ~  [6/10]: just cleanup for logging branch
>> [7/10] ~ [10/10]: introduce new traceevents
>>
>> Any comments are welcome!
>
> In sg3_utils there are now string yielding equivalents
> to the sense buffer "print" functions. They take a form
> like this:
>    char * get_sense_str(const unsigned char * sense_buffer,
>                         int sb_len, int blen, char * b);
>
> So this just does the hard work of decoding the sense buffer
> (or saying it is invalid) the result of which it places in
> buffer 'b'. And 'b' is returned (so this function can be in
> the arguments of a driver's printing function).
>
> Adding such string functions would give other parts of the
> SCSI subsystem the capability of tailoring their own
> messages that include sense data information.
>
>
> Existing sense buffer "print" function could be kept and
> implemented using the newer "_str" variants. Would that
> be worth the trouble?

I have already sent the idea using local buffer on this February,
but it was rejected by James (*1). By using stack region for local
buffer, stack overflow can occur. So, I implemented this feature
to atomically output an error message with device information.

(*1) https://lkml.org/lkml/2014/5/20/742

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


