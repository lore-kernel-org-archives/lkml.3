Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbaJDAXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:23:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbaJCVnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.16 196/357] gpio / ACPI: Use pin index and bit length
Date: Fri,  3 Oct 2014 14:29:42 -0700
Message-Id: <20141003212939.365947671@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit c15d821ddb9dac9ac6b5beb75bf942f3bc3a4004 upstream.

Fix code when the operation region callback is for an gpio, which
is not at index 0 and for partial pins in a GPIO definition.
For example:
Name (GMOD, ResourceTemplate ()
{
	//3 Outputs that define the Power mode of the device
	GpioIo (Exclusive, PullDown, , , , "\\_SB.GPI2") {10, 11, 12}
	})
}

If opregion callback calls is for:
- Set pin 10, then address = 0 and bit length = 1
- Set pin 11, then address = 1 and bit length = 1
- Set for both pin 11 and pin 12, then address = 1, bit length = 2

This change requires updated ACPICA gpio operation handler code to
send the pin index and bit length.

Fixes: 473ed7be0da0 (gpio / ACPI: Add support for ACPI GPIO operation regions)
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib-acpi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -357,8 +357,10 @@ acpi_gpio_adr_space_handler(u32 function
 	struct gpio_chip *chip = achip->chip;
 	struct acpi_resource_gpio *agpio;
 	struct acpi_resource *ares;
+	int pin_index = (int)address;
 	acpi_status status;
 	bool pull_up;
+	int length;
 	int i;
 
 	status = acpi_buffer_to_resource(achip->conn_info.connection,
@@ -380,7 +382,8 @@ acpi_gpio_adr_space_handler(u32 function
 		return AE_BAD_PARAMETER;
 	}
 
-	for (i = 0; i < agpio->pin_table_length; i++) {
+	length = min(agpio->pin_table_length, (u16)(pin_index + bits));
+	for (i = pin_index; i < length; ++i) {
 		unsigned pin = agpio->pin_table[i];
 		struct acpi_gpio_connection *conn;
 		struct gpio_desc *desc;


