Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3LSXa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:30:29 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46575 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3LSXa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:30:28 -0500
Message-ID: <52B38191.9090007@linaro.org>
Date: Thu, 19 Dec 2013 15:30:25 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH] ion_test: Add compat_ioctl support
References: <1387492830-7988-1-git-send-email-john.stultz@linaro.org> <CAMbhsRTLL7UfccyLeXraDx53SHXmBoVnKZE8fPcWzB1wsywo_Q@mail.gmail.com>
In-Reply-To: <CAMbhsRTLL7UfccyLeXraDx53SHXmBoVnKZE8fPcWzB1wsywo_Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 02:52 PM, Colin Cross wrote:
> On Thu, Dec 19, 2013 at 2:40 PM, John Stultz <john.stultz@linaro.org> wrote:
>> Prior to subitting this, Colin reworked the compat_ioctl support
>> for the ion_test driver, moving the structure to be the same size
>> on both 32 and 64 bit architectures.
>>
>> Two small things were left out. The compat_ioctl ptr assignment,
>> and the fact that despite having uniform sized types in the
>> structure, the structure pads out to different sizes on different
>> arches.
>>
>> This patch resolves this issue by setting the write flag as
>> a __u64, and adding the compat_ioctl ptr.
>>
>> While this does affect the ABI for 32bit users, its only
>> the ABI for the ion_test driver, not ion itself.
>>
>> Cc: Colin Cross <ccross@android.com>
>> Cc: Greg KH <gregkh@linuxfoundation.org>
>> Cc: Android Kernel Team <kernel-team@android.com>
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>> ---
>>  drivers/staging/android/ion/ion_test.c  | 1 +
>>  drivers/staging/android/uapi/ion_test.h | 2 +-
>>  2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/android/ion/ion_test.c b/drivers/staging/android/ion/ion_test.c
>> index 3e20349..654acb5 100644
>> --- a/drivers/staging/android/ion/ion_test.c
>> +++ b/drivers/staging/android/ion/ion_test.c
>> @@ -231,6 +231,7 @@ static int ion_test_release(struct inode *inode, struct file *file)
>>  static const struct file_operations ion_test_fops = {
>>         .owner = THIS_MODULE,
>>         .unlocked_ioctl = ion_test_ioctl,
>> +       .compat_ioctl = ion_test_ioctl,
> Setting the compat_ioctl to the same thing as unlocked_ioctl shouldn't
> be necessary, compat_sys_ioctl will fall through to do_vfs_ioctl if
> compat_ioctl is not set, which will call unlocked_ioctl.

Hrm. I've not looked into the implementation, but doesn't seem to be the
case on x86_64. Without it I get -1 back when calling the ioctl from a
32bit application. With it the ioctls work.


>
>>         .open = ion_test_open,
>>         .release = ion_test_release,
>>  };
>> diff --git a/drivers/staging/android/uapi/ion_test.h b/drivers/staging/android/uapi/ion_test.h
>> index 614d1e3..f1727f5 100644
>> --- a/drivers/staging/android/uapi/ion_test.h
>> +++ b/drivers/staging/android/uapi/ion_test.h
>> @@ -31,7 +31,7 @@ struct ion_test_rw_data {
>>         __u64 ptr;
>>         __u64 offset;
>>         __u64 size;
>> -       int write;
>> +       __u64 write;
>>  };
> Whoops, missed that one.  Can you add "int padding" after "int write"
> instead?  That at least lets us use the 32 bits later.

Will do.


thanks
-john


