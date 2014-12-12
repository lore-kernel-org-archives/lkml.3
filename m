Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031225AbaLLRat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:30:49 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:56805 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031014AbaLLRal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:30:41 -0500
Message-ID: <548B263E.6050502@hurleysoftware.com>
Date: Fri, 12 Dec 2014 12:30:38 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Imre Deak <imre.deak@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] vt: fix check for system/busy console drivers when
 unregistering them
References: <1418402285-9578-1-git-send-email-imre.deak@intel.com>
In-Reply-To: <1418402285-9578-1-git-send-email-imre.deak@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Imre,

On 12/12/2014 11:38 AM, Imre Deak wrote:
> System console drivers (without the CON_DRIVER_FLAG_MODULE flag) and
> busy drivers bound to a console (as reported by con_is_bound())
> shouldn't be unregistered. The current code checks for the
> CON_DRIVER_FLAG_INIT flag but this doesn't really correspond to either
> of the above two conditions. CON_DRIVER_FLAG_INIT is set whenever its
> associated console's con_startup() function is called, which first
> happens when the console driver is registered (so before the console
> gets bound) and gets cleared when the console gets unbound. The
> purpose of this flag is to show if we need to call con_startup() on a
> console before we use it.
> 
> Based on the above, do_unregister_con_driver() in its current form will
> incorrectly allow unregistering a console driver only if it was never
> bound, but will refuse to unregister one that was bound and later
> unbound. It will also allow unregistering a system console driver.
> 
> Fix this by checking for CON_DRIVER_FLAG_MODULE to refuse unregistering
> a system console driver and relying on the existing con_is_bound() check
> earlier in the function to refuse unregistering a busy console driver.

Maybe reword these two paragraphs?

"Allow non-system console drivers to unregister, and prevent system
console drivers from unregistering."

Regards,
Peter Hurley

> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  drivers/tty/vt/vt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index b33b00b..1862e89 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -3660,7 +3660,7 @@ int do_unregister_con_driver(const struct consw *csw)
>  		struct con_driver *con_driver = &registered_con_driver[i];
>  
>  		if (con_driver->con == csw &&
> -		    con_driver->flag & CON_DRIVER_FLAG_INIT) {
> +		    con_driver->flag & CON_DRIVER_FLAG_MODULE) {
>  			vtconsole_deinit_device(con_driver);
>  			device_destroy(vtconsole_class,
>  				       MKDEV(0, con_driver->node));
> 

