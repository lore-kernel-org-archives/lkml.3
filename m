Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab3BYVvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 16:51:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab3BYVvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 16:51:08 -0500
Message-ID: <512BDC82.5060203@redhat.com>
Date: Mon, 25 Feb 2013 16:49:54 -0500
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Zach Brown <zab@redhat.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <aviro@redhat.com>, "Martin K. Petersen" <mkp@mkp.net>,
        Hannes Reinecke <hare@suse.de>, Joel Becker <jlbec@evilplan.org>
Subject: Re: New copyfile system call - discuss before LSF?
References: <512606DF.5050706@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235D998C@SACEXCMBX04-PRD.hq.netapp.com> <512635D2.4090207@redhat.com> <51267CEB.8070805@redhat.com> <4FA345DA4F4AE44899BD2B03EEEC2FA9235DAA99@SACEXCMBX04-PRD.hq.netapp.com> <20130221222449.GY22221@lenny.home.zabbo.net> <512BD44C.40907@amacapital.net>
In-Reply-To: <512BD44C.40907@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2013 04:14 PM, Andy Lutomirski wrote:
> On 02/21/2013 02:24 PM, Zach Brown wrote:
>> On Thu, Feb 21, 2013 at 08:50:27PM +0000, Myklebust, Trond wrote:
>>> On Thu, 2013-02-21 at 21:00 +0100, Paolo Bonzini wrote:
>>>> Il 21/02/2013 15:57, Ric Wheeler ha scritto:
>>>>>> sendfile64() pretty much already has the right arguments for a
>>>>>> "copyfile", however it would be nice to add a 'flags' parameter: the
>>>>>> NFSv4.2 version would use that to specify whether or not to copy file
>>>>>> metadata.
>>>>> That would seem to be enough to me and has the advantage that it is an
>>>>> relatively obvious extension to something that is at least not totally
>>>>> unknown to developers.
>>>>>
>>>>> Do we need more than that for non-NFS paths I wonder? What does reflink
>>>>> need or the SCSI mechanism?
>>>> For virt we would like to be able to specify arbitrary block ranges.
>>>> Copying an entire file helps some copy operations like storage
>>>> migration.  However, it is not enough to convert the guest's offloaded
>>>> copies to host-side offloaded copies.
>>> So how would a system call based on sendfile64() plus my flag parameter
>>> prevent an underlying implementation from meeting your criterion?
>> If I'm guessing correctly, sendfile64()+flags would be annoying because
>> it's missing an out_fd_offset.  The host will want to offload the
>> guest's copies by calling sendfile on block ranges of a guest disk image
>> file that correspond to the mappings of the in and out files in the
>> guest.
>>
>> You could make it work with some locking and out_fd seeking to set the
>> write offset before calling sendfile64()+flags, but ugh.
>>
>>   ssize_t sendfile(int out_fd, int in_fd, off_t in_offset, off_t
>>                    out_offset, size_t count, int flags);
>>
>> That seems closer.
>>
>> We might also want to pre-emptively offer iovs instead of offsets,
>> because that's the very first thing that's going to be requested after
>> people prototype having to iterate calling sendfile() for each
>> contiguous copy region.
> I thought the first thing people would ask for is to atomically create a
> new file and copy the old file into it (at least on local file systems).
>   The idea is that nothing should see an empty destination file, either
> by race or by crash.  (This feature would perhaps be described as a
> pony, but it should be implementable.)
>
> This would be like a better link(2).
>
> --Andy

Why would this need to be atomic? That would seem to be a very difficult 
property to provide across all target types with multi-GB sized files...

Ric


