Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3BPJIP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 04:08:15 -0500
Received: from intranet.asianux.com ([58.214.24.6]:53211 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab3BPJIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 04:08:04 -0500
X-Spam-Score: -100.8
Message-ID: <511F4C6B.4030805@asianux.com>
Date: Sat, 16 Feb 2013 17:07:55 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, sameo@linux.intel.com
CC: Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] drivers/mfd/twl*: about power_count in twl6040_remove
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  if necessary to treat 'power_count' as a counter
    when power_count is more than 1, we do not really power off it.
    this may cause issue:
      after finish calling twl6040_remove, another modules still use it.
    suggest to give additional check, or synchronisation for other modules.

  else (not necessary to treat it as a counter)
    better to use it as a boolean value.
    it seems 'power_count' may still have chance to be more than 1:
      if it is true, we still may can not power off it in twl6040_remove.

  another question:
    may 'power_count' be a large number (which may cause value overflow) ?


  thanks.

gchen.


------------------------------------------------------------------------------

relative calls:

  drivers/mfd/twl6040.c:212:		twl6040_power(twl6040, 0);
  drivers/mfd/twl6040.c:215:		twl6040_power(twl6040, 1);
  drivers/mfd/twl6040.c:707:		twl6040_power(twl6040, 0);
  drivers/input/misc/twl6040-vibra.c:100:	twl6040_power(info->twl6040, 1);
  drivers/input/misc/twl6040-vibra.c:128:	twl6040_power(info->twl6040, 0);
  sound/soc/codecs/twl6040.c:911:		ret = twl6040_power(twl6040, 1);
  sound/soc/codecs/twl6040.c:926:		twl6040_power(twl6040, 0);
  drivers/clk/clk-twl6040.c:51:	ret = twl6040_power(twl6040_clk->twl6040, 1);
  drivers/clk/clk-twl6040.c:64:	ret = twl6040_power(twl6040_clk->twl6040, 0);



drivers/mfd/twl6040.c:

244 int twl6040_power(struct twl6040 *twl6040, int on)
245 {
246         int ret = 0;
247 
248         mutex_lock(&twl6040->mutex);
249 
250         if (on) {
251                 /* already powered-up */
252                 if (twl6040->power_count++)
253                         goto out;
254 
255                 if (gpio_is_valid(twl6040->audpwron)) {
256                         /* use automatic power-up sequence */
257                         ret = twl6040_power_up_automatic(twl6040);
258                         if (ret) {
259                                 twl6040->power_count = 0;
260                                 goto out;
261                         }
262                 } else {
263                         /* use manual power-up sequence */
264                         ret = twl6040_power_up_manual(twl6040);
265                         if (ret) {
266                                 twl6040->power_count = 0;
267                                 goto out;
268                         }
269                 }
270                 /* Default PLL configuration after power up */
271                 twl6040->pll = TWL6040_SYSCLK_SEL_LPPLL;
272                 twl6040->sysclk = 19200000;
273                 twl6040->mclk = 32768;
274         } else {
275                 /* already powered-down */
276                 if (!twl6040->power_count) {
277                         dev_err(twl6040->dev,
278                                 "device is already powered-off\n");
279                         ret = -EPERM;
280                         goto out;
281                 }
282 
283                 if (--twl6040->power_count)
284                         goto out;
285 
286                 if (gpio_is_valid(twl6040->audpwron)) {
287                         /* use AUDPWRON line */
288                         gpio_set_value(twl6040->audpwron, 0);
289 
290                         /* power-down sequence latency */
291                         usleep_range(500, 700);
292                 } else {
293                         /* use manual power-down sequence */
294                         twl6040_power_down_manual(twl6040);
295                 }
296                 twl6040->sysclk = 0;
297                 twl6040->mclk = 0;
298         }
299 
300 out:
301         mutex_unlock(&twl6040->mutex);
302         return ret;
303 }
304 EXPORT_SYMBOL(twl6040_power);
...

702 static int twl6040_remove(struct i2c_client *client)
703 {
704         struct twl6040 *twl6040 = i2c_get_clientdata(client);
705 
706         if (twl6040->power_count)
707                 twl6040_power(twl6040, 0);
708 
709         if (gpio_is_valid(twl6040->audpwron))
710                 gpio_free(twl6040->audpwron);
711 
712         free_irq(twl6040->irq_ready, twl6040);
713         free_irq(twl6040->irq_th, twl6040);
714         regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
715 
716         mfd_remove_devices(&client->dev);
717         i2c_set_clientdata(client, NULL);
718 
719         regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
720         regulator_bulk_free(TWL6040_NUM_SUPPLIES, twl6040->supplies);
721 
722         return 0;
723 }

-----------------------------------------------------------------------------------



