Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaJTXcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:32:55 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:36424 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaJTXcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <20141020092049.GJ23154@mwanda>
References: <20141016124741.GA3832@kroah.com>
	<20141017092601.GH23154@mwanda>
	<20141019220547.GC3780@kroah.com>
	<20141020092049.GJ23154@mwanda>
Date: Mon, 20 Oct 2014 16:32:51 -0700
Message-ID: <CAMP5Xgcm-sxd3rf3VA1ZO44bUT1+u_QG1AAdjzK39q0ynfsZGQ@mail.gmail.com>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the kernel
From: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Anup Patel <anup.patel@linaro.org>, linux-api@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 2:20 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Mon, Oct 20, 2014 at 06:05:47AM +0800, Greg Kroah-Hartman wrote:
>> On Fri, Oct 17, 2014 at 12:26:01PM +0300, Dan Carpenter wrote:
>> > The code isn't very beautiful and there are lots of details wrong like
>> > the error codes.
>>
>> Really, what is wrong with the existing error code usages?
>>
>
> I guess I was mostly looking at binder_ioctl(), the rest of the code
> seems better.
>
> I feel like we went directly from "This code is never going in so there
> is no need to look at it." to "This code is going in in one week so
> there is no time to look at it."
>
> How often do people rely on proc_no_lock=1 to make this work?  People
> are saying on the internet that you don't need acurate information so
> you should disable locking as a speed up.
> http://www.programdevelop.com/1821706/.  It seems like a bad idea to
> provide provide the "run fast and crash" option.

That is not what this switch is for. It is only there to debug the
driver if it gets stuck with the lock held. I would not object to
adding a config option to remove this param by default.

>
> Why is binder_set_nice needed?  Some comments would help here.

The driver has some support for priority inheritance.

>
>    434  static void binder_set_nice(long nice)
>    435  {
>    436          long min_nice;
>    437
>    438          if (can_nice(current, nice)) {
>    439                  set_user_nice(current, nice);
>    440                  return;
>    441          }
>    442          min_nice = rlimit_to_nice(current->signal->rlim[RLIMIT_NICE].rlim_cur);
>    443          binder_debug(BINDER_DEBUG_PRIORITY_CAP,
>    444                       "%d: nice value %ld not allowed use %ld instead\n",
>    445                        current->pid, nice, min_nice);
>    446          set_user_nice(current, min_nice);
>    447          if (min_nice <= MAX_NICE)
>    448                  return;
>
> It's harmless but wierd to check if min_nice is valid after we already
> called set_user_nice().

I don't remember why I did this, but I agree it is weird.

>
>    449          binder_user_error("%d RLIMIT_NICE not set\n", current->pid);
>    450  }
>
> Random comment:
>
>    709          has_page_addr =
>    710                  (void *)(((uintptr_t)buffer->data + buffer_size) & PAGE_MASK);
>
> The casting on "buffer->data" ugly and inconsistent.  There should be
> a function:

Other code in the kernel seems to do this the same way (although most
cast to unsigned long instead of uintptr_t). This code rounds down to
the start of of the page, and needs to cast to an integer type for
this. Adding a global kernel helper for this would be better than a
binder specific one. The existing PAGE_ALIGN function, which rounds
up, still needs casts to use with pointer types though.

> void *buffer_data(struct binder_buffer *buffer)
> {
>         return buffer.data;
> }
>
> That way this becomes:
>                 has_page_addr = (buffer_data(buffer) + buffer_size) & PAGE_MASK);

I don't think this will compile.

>
> The "has_page_addr" variable name is misleading, because we're not
> storing true/false.  We're storing the last page address.

It is the address of a page we already have mapped, not the last
address of the new allocation.

>
>    711          if (n == NULL) {
>    712                  if (size + sizeof(struct binder_buffer) + 4 >= buffer_size)
>    713                          buffer_size = size; /* no room for other buffers */
>    714                  else
>    715                          buffer_size = size + sizeof(struct binder_buffer);
>    716          }
>    717          end_page_addr =
>    718                  (void *)PAGE_ALIGN((uintptr_t)buffer->data + buffer_size);
>    719          if (end_page_addr > has_page_addr)
>    720                  end_page_addr = has_page_addr;
>    721          if (binder_update_page_range(proc, 1,
>    722              (void *)PAGE_ALIGN((uintptr_t)buffer->data), end_page_addr, NULL))
>    723                  return NULL;
>
> The alignment here is confusing because we don't align buffer->data
> below.

binder_update_page_range allocates and maps pages. buffer->data will
point to a range within the allocated pages.

>
>    724
>    725          rb_erase(best_fit, &proc->free_buffers);
>    726          buffer->free = 0;
>    727          binder_insert_allocated_buffer(proc, buffer);
>    728          if (buffer_size != size) {
>    729                  struct binder_buffer *new_buffer = (void *)buffer->data + size;
>                                                            ^^^^^^^^^^^^^^^^^^^^
> I don't really understand when buffer->data has to be page aligned and
> when not.  This code has very few comments.
>

buffer->data never needs to be page aligned. The code above rounds to
page boundaries to allocate new pages as needed.

>    730
>    731                  list_add(&new_buffer->entry, &buffer->entry);
>    732                  new_buffer->free = 1;
>    733                  binder_insert_free_buffer(proc, new_buffer);
>    734          }
>
> Does the stop_on_user_error option work?  There should be some
> documentation for this stuff.
>

Yes.

> regards,
> dan carpenter
>

-- 
Arve Hjønnevåg
