Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaC2WIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 18:08:34 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:45995 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaC2WId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 18:08:33 -0400
Message-ID: <5337445E.3080903@gmail.com>
Date: Sat, 29 Mar 2014 18:08:30 -0400
From: Alexandre Demers <alexandre.f.demers@gmail.com>
Reply-To: alexandre.f.demers@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [Regression, bisected 9e30cc] "sysfs, kernfs: no need to kern_mount()
 sysfs from sysfs_init()" prevents system from booting correctly
References: <CAPEhTTFP3N-ReasmgL5n82mve8p8M3crqmaMvzV+F2p5JCSRbQ@mail.gmail.com> <20140314140804.GG12613@htj.dyndns.org> <CAPEhTTG3kCDk2V9dbCB5mATKt2nyVj9iiv9g5MTOEbqYrpPefg@mail.gmail.com> <20140317201346.GE17373@mtj.dyndns.org> <5327AAA8.2080703@gmail.com> <53322777.3030703@gmail.com> <20140326131800.GA7171@htj.dyndns.org> <CAPEhTTGyA7SjedwL8Mv-ZDEY_doucW3thPr==xyOemm3+Vp=Cg@mail.gmail.com> <20140329181258.GF5553@htj.dyndns.org>
In-Reply-To: <20140329181258.GF5553@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That fixes the problem, I'm now running 3.14-rc8 with your patch 
applied.

Alexandre Demers

On Sat 29 Mar 2014 02:12:58 PM EDT, Tejun Heo wrote:
> Hello, Alexander.
>
> On Thu, Mar 27, 2014 at 01:47:53PM -0400, Alexandre Demers wrote:
>> I'll do my best, but I just don't have enough time right now for
>> everything I have to do at home and dig this bug. I may be able to
>> look at it in the next couple of days though, or it may go somewhere
>> next week... That being said, I tried yesterday to have a better idea
>> and I thank you for the "ScrLck" trick, I didn't know that it was
>> working. Nevertheless I didn't find anything.
>>
>> It seems as if the transition from the temporary kernel's fs to the
>> hard disk's fs is not done correctly. If I boot with a working kernel
>> after that, I can't find any trace of where it was trying to copy the
>> files or of any partition being full. Could it be filling the RAM
>> until it reaches its maximum capacity (16GB to fill before hitting the
>> limit and throwing the errors)? That would explain at least why it
>> takes so much time before the flood of errors begins...
>
> That could definitely be the case.  I'd really like to get to the
> bottom of it.  It's really curious that there aren't more people
> reporting the same problem.  Can you please try whether the following
> patch makes the regression go away?
>
> Thanks!
>
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index a66ad61..a3223e2 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -75,5 +75,7 @@ int __init sysfs_init(void)
>   		return err;
>   	}
>
> +	WARN_ON(IS_ERR(kern_mount(&sysfs_fs_type)));
> +
>   	return 0;
>   }
