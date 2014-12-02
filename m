Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbaLBCDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 21:03:51 -0500
Received: from mout.gmx.net ([212.227.17.20]:55769 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbaLBCDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 21:03:50 -0500
Message-ID: <547D1E01.90900@gmx.de>
Date: Tue, 02 Dec 2014 03:03:45 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: eparis@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] fanotify: fix inconsistent behaviour regarding flag
 FAN_ONDIR
References: <1417304258-16838-1-git-send-email-LinoSanfilippo@gmx.de> <1417304258-16838-3-git-send-email-LinoSanfilippo@gmx.de> <20141201100547.GD16185@quack.suse.cz>
In-Reply-To: <20141201100547.GD16185@quack.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:2phX7URBiBBJcsjC8Swu1Oh4edfXzgeldMmoiUG5/Ba+4TjpDnf
 w2OJc60Nk5/OZMuXdSZ560rzh7EJneCxezw44hgBB9ECMwWLlS6b91a3CQcJuFXeCafit5y
 QhLIsyD1MoN2vQKEwzrVzvOKbKo3B6DT59lvsO3tdxizJt+CCF+jKWo+2x/TzcZ8eCYtkpv
 dx7QbDU1S3zesZJTMCL3Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01.12.2014 11:05, Jan Kara wrote:
> On Sun 30-11-14 00:37:38, Lino Sanfilippo wrote:
>> Before flag FAN_ONDIR was implicitly set in a marks ignored mask. This led to
>> some inconsistent behaviour:
>> 
>> 1. It was not possible to remove the flag from the ignored mask, once it was set
>> (implicitly) with a call like
>> 
>> fanotify_mark(fd, FAN_MARK_ADD, FAN_OPEN, AT_FDCWD, "dir");
>> 
>> This was since the needed flag FAN_MARK_ONDIR was only honored when setting a
>> marks mask, but not when removing it. Now FAN_ONDIR is only set when explicitly
>> passed in the masks parameter. It now is also possible to remove it again:
>> 
>> fanotify_mark(fd, FAN_MARK_ADD, FAN_OPEN | FAN_ONDIR , AT_FDCWD, "dir");
>> fanotify_mark(fd, FAN_MARK_REMOVE, FAN_ONDIR , AT_FDCWD, "dir");
>> 
>> 2. Subsequent calls to fanotify_mark for a mark that had FAN_ONDIR already set
>> in its mask removed the flag, if it was not specified in the mask parameter
>> again. Thus
>> 
>> fanotify_mark(fd, FAN_MARK_ADD, FAN_OPEN | FAN_ONDIR , AT_FDCWD, "dir");
>> fanotify_mark(fd, FAN_MARK_ADD, FAN_CLOSE, AT_FDCWD, "dir");
>> 
>> set FAN_ONDIR in the first call on the marks mask but also on the ignored
>> mask in the second call. So the first request for DIR events was overwritten.
>> Since the flag is now not set implicitly any longer this cant happen any more.
>   Ugh, I have to say I don't understand the changelog. From the code I
> think I understood that instead of always adding FAN_ONDIR to ignore mask
> you require FAN_ONDIR to be set in the normal mask. That makes sense to me
> but please make the changelog more comprehensible.

Hm. My intention was to describe at least two cases of strange behaviour
when setting the FAN_ONDIR flag. But maybe the description has indeed
become a little bit too complicated. I will adjust that and resend the
patch.

 Also please add a
> testcase to LTP fanotify() coverage for FAN_ONDIR behavior so that we can
> easily see how userspace visible behavior changed / didn't change. Thanks!
> 

Ok, i can do that (it may take a few days until i find the time for it
though). Thank you for review!

Regards,
Lino
