Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161258AbaJ3UiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 16:38:21 -0400
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:33029 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934774AbaJ3UiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 16:38:18 -0400
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <5452A1B1.7010809@mev.co.uk>
Date: Thu, 30 Oct 2014 20:38:09 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: comedi: comedi_test: fix timer lock-up
References: <1414501642-14261-1-git-send-email-abbotti@mev.co.uk> <1414663433-11137-1-git-send-email-abbotti@mev.co.uk> <20141030202918.GA27910@kroah.com>
In-Reply-To: <20141030202918.GA27910@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/10/14 20:29, Greg Kroah-Hartman wrote:
> On Thu, Oct 30, 2014 at 10:03:53AM +0000, Ian Abbott wrote:
>> Commit 240512474424 ("staging: comedi: comedi_test: use
>> comedi_handle_events()") resulted in the timer routine
>> `waveform_ai_interrupt()` calling `comedi_handle_events()` instead of
>> `comedi_events()`.  That had the advantage of automatically stopping the
>> acquisition on overflow/error/end-of-acquisition conditions (by calling
>> the comedi subdevice's "cancel" handler), but currently results in the
>> timer routine locking when one of those conditions occur.  This is
>> because the "cancel" handler `waveform_ai_cancel()` calls
>> `del_timer_sync()`.
>>
>> Fix it by adding a bit to the device private data that indicates whether
>> the acquisition is active or not, and changing the "cancel" handler to
>> use `del_timer()` instead of `del_timer_sync()`.  The bit is set when
>> starting the acquisition, cleared when ending the acquisition (in the
>> "cancel" handler), and tested in the timer routine, which will do
>> nothing if the acquisition is inactive.  Also, make sure any scheduled
>> timeout event gets cancelled when the low-level device gets "detached"
>> from the comedi core by calling `del_timer_sync()` in the "detach"
>> handler `waveform_detach()`.
>>
>> Fixes: 240512474424 ("staging: comedi: comedi_test: use comedi_handle_events()")
>> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
>> ---
>> v2: rebased after commit dd28153b2a8ca
>> Greg, this fix is for "linux-next" and "staging-next".
>
> I don't understand, I've already taken this patch, right?  It doesn't
> apply to my branch :(

So you have.  Ignore v2 then.  (I got a merge merge conflict when I 
tried it, which is why I sent the rebased version.)

Thanks.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
