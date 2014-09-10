Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaIJIGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:06:14 -0400
Received: from sym2.noone.org ([178.63.92.236]:43243 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbaIJIGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:06:02 -0400
Date: Wed, 10 Sep 2014 10:05:58 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        linux-serial@vger.kernel.org
Subject: Re: randconfig build error with next-20140909, in
 drivers/tty/serial/serial_mctrl_gpio.c
Message-ID: <20140910080558.GB14260@distanz.ch>
References: <CA+r1ZhjCZBWjkxjoJz=PO-YZg6LbghQV75tGnpiSOrHM9CaygA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+r1ZhjCZBWjkxjoJz=PO-YZg6LbghQV75tGnpiSOrHM9CaygA@mail.gmail.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-10 at 00:32:25 +0200, Jim Davis <jim.epost@gmail.com> wrote:
> Building with the attached random configuration file,
> 
> drivers/tty/serial/serial_mctrl_gpio.c:44:6: error: redefinition of
> ‘mctrl_gpio_set’
>  void mctrl_gpio_set(struct mctrl_gpios *gpios, unsigned int mctrl)
>       ^
> In file included from drivers/tty/serial/serial_mctrl_gpio.c:23:0:
> drivers/tty/serial/serial_mctrl_gpio.h:80:6: note: previous definition
> of ‘mctrl_gpio_set’ was here
>  void mctrl_gpio_set(struct mctrl_gpios *gpios, unsigned int mctrl)
>       ^
> drivers/tty/serial/serial_mctrl_gpio.c:59:19: error: redefinition of
> ‘mctrl_gpio_to_gpiod’
>  struct gpio_desc *mctrl_gpio_to_gpiod(struct mctrl_gpios *gpios,
>                    ^
> In file included from drivers/tty/serial/serial_mctrl_gpio.c:23:0:
> drivers/tty/serial/serial_mctrl_gpio.h:91:19: note: previous
> definition of ‘mctrl_gpio_to_gpiod’ was here
>  struct gpio_desc *mctrl_gpio_to_gpiod(struct mctrl_gpios *gpios,
>                    ^
> drivers/tty/serial/serial_mctrl_gpio.c:69:14: error: redefinition of
> ‘mctrl_gpio_get’
>  unsigned int mctrl_gpio_get(struct mctrl_gpios *gpios, unsigned int *mctrl)
>               ^
> In file included from drivers/tty/serial/serial_mctrl_gpio.c:23:0:
> drivers/tty/serial/serial_mctrl_gpio.h:85:14: note: previous
> definition of ‘mctrl_gpio_get’ was here
>  unsigned int mctrl_gpio_get(struct mctrl_gpios *gpios, unsigned int *mctrl)
>               ^
> drivers/tty/serial/serial_mctrl_gpio.c:93:21: error: redefinition of
> ‘mctrl_gpio_init’
>  struct mctrl_gpios *mctrl_gpio_init(struct device *dev, unsigned int idx)
>                      ^
> In file included from drivers/tty/serial/serial_mctrl_gpio.c:23:0:
> drivers/tty/serial/serial_mctrl_gpio.h:98:21: note: previous
> definition of ‘mctrl_gpio_init’ was here
>  struct mctrl_gpios *mctrl_gpio_init(struct device *dev, unsigned int idx)
>                      ^
> drivers/tty/serial/serial_mctrl_gpio.c:131:6: error: redefinition of
> ‘mctrl_gpio_free’
>  void mctrl_gpio_free(struct device *dev, struct mctrl_gpios *gpios)
>       ^
> In file included from drivers/tty/serial/serial_mctrl_gpio.c:23:0:
> drivers/tty/serial/serial_mctrl_gpio.h:104:6: note: previous
> definition of ‘mctrl_gpio_free’ was here
>  void mctrl_gpio_free(struct device *dev, struct mctrl_gpios *gpios)
>       ^
>   CC [M]  drivers/net/wireless/ti/wl1251/io.o
> make[3]: *** [drivers/tty/serial/serial_mctrl_gpio.o] Error 1

The problem seems to be that if GPIOLIB is not selected, the noop
functions from serial_mctrl_gpio.h are pulled in, but
serial_mctrl_gpio.c is still compiled. Since all drivers that include
serial_mctrl_gpio.h also depend on SERIAL_MCTRL_GPIO I'd suggest adding
a "select GPIOLIB" to config SERIAL_MCTRL_GPIO and removing the
noop functions alltogether, see patch below:

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 8079f52..5f1ea62 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1575,5 +1575,6 @@ endmenu
 
 config SERIAL_MCTRL_GPIO
 	tristate
+	select GPIOLIB
 
 endif # TTY
diff --git a/drivers/tty/serial/serial_mctrl_gpio.h b/drivers/tty/serial/serial_mctrl_gpio.h
index 400ba04..5e4c96a 100644
--- a/drivers/tty/serial/serial_mctrl_gpio.h
+++ b/drivers/tty/serial/serial_mctrl_gpio.h
@@ -40,8 +40,6 @@ enum mctrl_gpio_idx {
  */
 struct mctrl_gpios;
 
-#ifdef CONFIG_GPIOLIB
-
 /*
  * Set state of the modem control output lines via GPIOs.
  */
@@ -74,37 +72,4 @@ struct mctrl_gpios *mctrl_gpio_init(struct device *dev, unsigned int idx);
  */
 void mctrl_gpio_free(struct device *dev, struct mctrl_gpios *gpios);
 
-#else /* GPIOLIB */
-
-static inline
-void mctrl_gpio_set(struct mctrl_gpios *gpios, unsigned int mctrl)
-{
-}
-
-static inline
-unsigned int mctrl_gpio_get(struct mctrl_gpios *gpios, unsigned int *mctrl)
-{
-	return *mctrl;
-}
-
-static inline
-struct gpio_desc *mctrl_gpio_to_gpiod(struct mctrl_gpios *gpios,
-				      enum mctrl_gpio_idx gidx)
-{
-	return ERR_PTR(-ENOSYS);
-}
-
-static inline
-struct mctrl_gpios *mctrl_gpio_init(struct device *dev, unsigned int idx)
-{
-	return ERR_PTR(-ENOSYS);
-}
-
-static inline
-void mctrl_gpio_free(struct device *dev, struct mctrl_gpios *gpios)
-{
-}
-
-#endif /* GPIOLIB */
-
 #endif
